note
	description: "[
		GitHub-based package registry.

		Fetches package information from the simple-eiffel GitHub organization.
		Uses GitHub API to:
		- List all repositories (packages)
		- Get repository metadata
		- Fetch ECF files for dependency information
		- Get available versions (git tags)

		No authentication required for public repositories.
		Rate limit: 60 requests/hour unauthenticated.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	PKG_REGISTRY

create
	make

feature {NONE} -- Initialization

	make (a_config: PKG_CONFIG)
			-- Initialize registry with configuration.
		require
			config_not_void: a_config /= Void
		do
			config := a_config
			create http.make
			create package_cache.make (50)
			create last_errors.make (10)
		ensure
			config_set: config = a_config
		end

feature -- Access

	config: PKG_CONFIG
			-- Configuration

	http: SIMPLE_HTTP
			-- HTTP client for API calls

	package_cache: HASH_TABLE [PKG_INFO, STRING]
			-- Cache of fetched package info

	last_errors: ARRAYED_LIST [STRING]
			-- Errors from last operation

	has_error: BOOLEAN
			-- Did last operation have errors?
		do
			Result := not last_errors.is_empty
		end

feature -- Package Fetching

	fetch_package (a_name: STRING): detachable PKG_INFO
			-- Fetch package info by name.
		require
			name_not_empty: not a_name.is_empty
		local
			l_normalized: STRING
			l_url: STRING
			l_response: detachable STRING
			l_json: SIMPLE_JSON
		do
			last_errors.wipe_out
			l_normalized := config.normalize_package_name (a_name)

			-- Check cache first
			if attached package_cache.item (l_normalized) as cached then
				Result := cached
			else
				-- Fetch from GitHub API
				l_url := config.github_api_base + "/repos/" + config.github_org + "/" + l_normalized

				l_response := http_get (l_url)

				if attached l_response as resp then
					create l_json
					if attached l_json.parse (resp) as l_parsed then
						if l_parsed.is_object and then not l_parsed.as_object.has_key ("message") then
							create Result.make_from_json (l_parsed)
							-- Fetch dependencies from ECF
							fetch_dependencies (Result)
							-- Cache it
							package_cache.force (Result, l_normalized)
						else
							if l_parsed.is_object and then attached l_parsed.as_object.string_item ("message") as msg then
								last_errors.extend ("GitHub API: " + msg.to_string_8)
							end
						end
					end
				end
			end
		end

	fetch_all_packages: ARRAYED_LIST [PKG_INFO]
			-- Fetch all packages from the registry.
		local
			l_url: STRING
			l_response: detachable STRING
			l_json: SIMPLE_JSON
			l_array: detachable SIMPLE_JSON_ARRAY
			i: INTEGER
		do
			create Result.make (70)
			last_errors.wipe_out

			-- Fetch organization repos (paginated, up to 100 per page)
			l_url := config.github_api_base + "/orgs/" + config.github_org + "/repos?per_page=100&type=public"

			l_response := http_get (l_url)

			if attached l_response as resp then
				create l_json
				if attached l_json.parse (resp) as l_parsed and then l_parsed.is_array then
					l_array := l_parsed.as_array
					if attached l_array as arr then
						from i := 1 until i > arr.count loop
							if attached arr.item (i) as item_json and then item_json.is_object then
								if attached item_json.as_object.string_item ("name") as repo_name then
									-- Only include simple_* repositories
									if repo_name.starts_with ("simple_") and then
									   not repo_name.same_string_general ("simple-eiffel.github.io") then
										Result.extend (create {PKG_INFO}.make_from_json (item_json))
									end
								end
							end
							i := i + 1
						end
					end
				else
					last_errors.extend ("Failed to parse repository list")
				end
			end
		ensure
			result_attached: Result /= Void
		end

	search_packages (a_query: STRING): ARRAYED_LIST [PKG_INFO]
			-- Search for packages matching `a_query`.
		require
			query_not_empty: not a_query.is_empty
		local
			l_all: ARRAYED_LIST [PKG_INFO]
			l_query_lower: STRING
		do
			create Result.make (20)
			l_query_lower := a_query.as_lower
			l_all := fetch_all_packages

			across l_all as pkg loop
				if pkg.name.as_lower.has_substring (l_query_lower) or else
				   pkg.description.as_lower.has_substring (l_query_lower) then
					Result.extend (pkg)
				end
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Version Management

	fetch_versions (a_name: STRING): ARRAYED_LIST [STRING]
			-- Fetch available versions (git tags) for package.
		require
			name_not_empty: not a_name.is_empty
		local
			l_normalized: STRING
			l_url: STRING
			l_response: detachable STRING
			l_json: SIMPLE_JSON
			l_array: detachable SIMPLE_JSON_ARRAY
			i: INTEGER
		do
			create Result.make (10)
			l_normalized := config.normalize_package_name (a_name)

			l_url := config.github_api_base + "/repos/" + config.github_org + "/" + l_normalized + "/tags"

			l_response := http_get (l_url)

			if attached l_response as resp then
				create l_json
				if attached l_json.parse (resp) as l_parsed and then l_parsed.is_array then
					l_array := l_parsed.as_array
					if attached l_array as arr then
						from i := 1 until i > arr.count loop
							if attached arr.item (i) as tag_json and then tag_json.is_object then
								if attached tag_json.as_object.string_item ("name") as tag_name then
									Result.extend (tag_name.to_string_8)
								end
							end
							i := i + 1
						end
					end
				end
			end
		ensure
			result_attached: Result /= Void
		end

	fetch_latest_version (a_name: STRING): STRING
			-- Fetch latest version for package (latest tag or "main").
		require
			name_not_empty: not a_name.is_empty
		local
			l_versions: ARRAYED_LIST [STRING]
		do
			l_versions := fetch_versions (a_name)
			if l_versions.is_empty then
				Result := "main"
			else
				Result := l_versions.first
			end
		ensure
			result_not_empty: not Result.is_empty
		end

feature -- ECF Fetching

	fetch_ecf_content (a_name: STRING): detachable STRING
			-- Fetch ECF file content for package.
		require
			name_not_empty: not a_name.is_empty
		local
			l_normalized: STRING
			l_url: STRING
		do
			l_normalized := config.normalize_package_name (a_name)

			-- Try standard ECF location: simple_name/simple_name.ecf
			l_url := config.github_raw_base + "/" + config.github_org + "/" +
			         l_normalized + "/main/" + l_normalized + ".ecf"

			Result := http_get (l_url)

			-- If not found, try without branch
			if Result = Void or else Result.has_substring ("404") then
				l_url := config.github_raw_base + "/" + config.github_org + "/" +
				         l_normalized + "/master/" + l_normalized + ".ecf"
				Result := http_get (l_url)
			end
		end

feature {NONE} -- Implementation

	fetch_dependencies (a_package: PKG_INFO)
			-- Fetch and parse dependencies from ECF file.
		require
			package_not_void: a_package /= Void
		local
			l_ecf: detachable STRING
			l_deps: ARRAYED_LIST [STRING]
		do
			l_ecf := fetch_ecf_content (a_package.name)
			if attached l_ecf as ecf_content then
				l_deps := parse_ecf_dependencies (ecf_content)
				a_package.set_dependencies (l_deps)
			end
		end

	parse_ecf_dependencies (a_ecf_content: STRING): ARRAYED_LIST [STRING]
			-- Parse ECF content and extract simple_* dependencies.
		require
			content_not_empty: not a_ecf_content.is_empty
		local
			l_start, l_end: INTEGER
			l_location: STRING
		do
			create Result.make (10)

			-- Simple parsing: find all library location="$SIMPLE_*" entries
			from
				l_start := 1
			until
				l_start = 0
			loop
				l_start := a_ecf_content.substring_index ("$SIMPLE_", l_start)
				if l_start > 0 then
					-- Find the end of the path
					l_end := a_ecf_content.index_of ('/', l_start)
					if l_end = 0 then
						l_end := a_ecf_content.index_of ('\', l_start)
					end
					if l_end = 0 then
						l_end := a_ecf_content.index_of ('"', l_start)
					end
					if l_end > l_start then
						l_location := a_ecf_content.substring (l_start + 1, l_end - 1)
						-- Convert SIMPLE_JSON to simple_json
						l_location := l_location.as_lower
						if not Result.has (l_location) then
							Result.extend (l_location)
						end
					end
					l_start := l_start + 1
				end
			end
		ensure
			result_attached: Result /= Void
		end

	http_get (a_url: STRING): detachable STRING
			-- Perform HTTP GET request.
		require
			url_not_empty: not a_url.is_empty
		local
			l_response: SIMPLE_HTTP_RESPONSE
		do
			http.add_header ("User-Agent", "simple_pkg/1.0")
			http.add_header ("Accept", "application/vnd.github.v3+json")
			l_response := http.get (a_url)

			if l_response.is_success then
				Result := l_response.body_string
			else
				last_errors.extend ("HTTP error " + l_response.status.out + " for " + a_url)
			end
		end

invariant
	config_exists: config /= Void
	http_exists: http /= Void
	cache_exists: package_cache /= Void

end
