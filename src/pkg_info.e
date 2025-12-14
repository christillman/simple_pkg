note
	description: "[
		Package information structure.

		Holds metadata about a package:
		- Name, description, version
		- Dependencies (from ECF)
		- GitHub repository info
		- Installation status
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	PKG_INFO

create
	make,
	make_from_json

feature {NONE} -- Initialization

	make (a_name: STRING)
			-- Create package info with `a_name`.
		require
			name_not_empty: not a_name.is_empty
		do
			name := a_name
			create description.make_empty
			create version.make_empty
			create dependencies.make (5)
			create github_url.make_empty
			create ecf_path.make_empty
			create local_path.make_empty
			create author.make_empty
			create keywords.make (5)
			create category.make_empty
			create license.make_empty
		ensure
			name_set: name.same_string (a_name)
		end

	make_from_json (a_json: SIMPLE_JSON_VALUE)
			-- Create package info from JSON object.
		require
			json_is_object: a_json.is_object
		local
			l_obj: SIMPLE_JSON_OBJECT
		do
			l_obj := a_json.as_object

			name := if attached l_obj.string_item ("name") as n then n.to_string_8 else "" end
			description := if attached l_obj.string_item ("description") as d then d.to_string_8 else "" end
			version := if attached l_obj.string_item ("default_branch") as v then v.to_string_8 else "main" end
			github_url := if attached l_obj.string_item ("html_url") as u then u.to_string_8 else "" end
			clone_url := if attached l_obj.string_item ("clone_url") as c then c.to_string_8 else "" end

			create dependencies.make (5)
			create ecf_path.make_empty
			create local_path.make_empty
			create author.make_empty
			create keywords.make (5)
			create category.make_empty
			create license.make_empty

			-- Extract stars and other metadata
			stars := l_obj.integer_item ("stargazers_count").to_integer_32
			is_archived := l_obj.boolean_item ("archived")
		ensure
			name_set: not name.is_empty or else not a_json.as_object.has_key ("name")
		end

feature -- Access

	name: STRING
			-- Package name (e.g., "simple_json")

	description: STRING
			-- Package description

	version: STRING
			-- Current version (git tag or branch)

	version_major: INTEGER
			-- Semantic version major

	version_minor: INTEGER
			-- Semantic version minor

	version_release: INTEGER
			-- Semantic version patch/release

	dependencies: ARRAYED_LIST [STRING]
			-- List of dependency package names

	github_url: STRING
			-- GitHub repository URL

	clone_url: detachable STRING
			-- Git clone URL

	ecf_path: STRING
			-- Path to ECF file within repository

	local_path: STRING
			-- Local installation path

	stars: INTEGER
			-- GitHub stars count

	is_archived: BOOLEAN
			-- Is the repository archived?

	is_installed: BOOLEAN
			-- Is this package installed locally?

	author: STRING
			-- Package author

	keywords: ARRAYED_LIST [STRING]
			-- Search keywords

	category: STRING
			-- Package category

	license: STRING
			-- License type

feature -- Status

	short_name: STRING
			-- Name without "simple_" prefix.
		do
			if name.starts_with ("simple_") then
				Result := name.substring (8, name.count)
			else
				Result := name
			end
		ensure
			result_not_empty: not Result.is_empty
		end

	env_var_name: STRING
			-- Environment variable name (e.g., "SIMPLE_JSON").
		do
			Result := name.as_upper
		ensure
			result_uppercase: Result.same_string (Result.as_upper)
		end

feature -- Modification

	set_description (a_description: STRING)
			-- Set description.
		do
			description := a_description
		ensure
			description_set: description.same_string (a_description)
		end

	set_version (a_version: STRING)
			-- Set version.
		require
			version_not_empty: not a_version.is_empty
		do
			version := a_version
		ensure
			version_set: version.same_string (a_version)
		end

	set_github_url (a_url: STRING)
			-- Set GitHub URL.
		do
			github_url := a_url
		ensure
			url_set: github_url.same_string (a_url)
		end

	set_clone_url (a_url: STRING)
			-- Set clone URL.
		do
			clone_url := a_url
		ensure
			url_set: attached clone_url as u and then u.same_string (a_url)
		end

	set_local_path (a_path: STRING)
			-- Set local installation path.
		do
			local_path := a_path
		ensure
			path_set: local_path.same_string (a_path)
		end

	set_installed (a_value: BOOLEAN)
			-- Set installation status.
		do
			is_installed := a_value
		ensure
			installed_set: is_installed = a_value
		end

	add_dependency (a_dep: STRING)
			-- Add a dependency.
		require
			dep_not_empty: not a_dep.is_empty
		do
			if not dependencies.has (a_dep) then
				dependencies.extend (a_dep)
			end
		ensure
			has_dependency: dependencies.has (a_dep)
		end

	set_dependencies (a_deps: ARRAYED_LIST [STRING])
			-- Set all dependencies.
		do
			dependencies := a_deps
		ensure
			dependencies_set: dependencies = a_deps
		end

	set_author (a_author: STRING)
			-- Set author.
		do
			author := a_author
		ensure
			author_set: author.same_string (a_author)
		end

	set_keywords (a_keywords: ARRAYED_LIST [STRING])
			-- Set keywords.
		do
			keywords := a_keywords
		ensure
			keywords_set: keywords = a_keywords
		end

	set_category (a_category: STRING)
			-- Set category.
		do
			category := a_category
		ensure
			category_set: category.same_string (a_category)
		end

	set_license (a_license: STRING)
			-- Set license.
		do
			license := a_license
		ensure
			license_set: license.same_string (a_license)
		end

	set_semantic_version (a_major, a_minor, a_release: INTEGER)
			-- Set semantic version components.
		require
			non_negative: a_major >= 0 and a_minor >= 0 and a_release >= 0
		do
			version_major := a_major
			version_minor := a_minor
			version_release := a_release
			version := a_major.out + "." + a_minor.out + "." + a_release.out
		ensure
			major_set: version_major = a_major
			minor_set: version_minor = a_minor
			release_set: version_release = a_release
		end

	apply_ecf_metadata (a_metadata: ECF_METADATA)
			-- Apply metadata from ECF parsing.
		require
			metadata_valid: a_metadata.is_valid
		do
			-- Update description if ECF has one and current is empty
			if description.is_empty and not a_metadata.description.is_empty then
				description := a_metadata.description
			end

			-- Set version from ECF
			if a_metadata.has_version then
				set_semantic_version (a_metadata.version_major, a_metadata.version_minor, a_metadata.version_release)
			end

			-- Set dependencies from ECF
			dependencies := a_metadata.dependencies

			-- Set author, keywords, category, license
			if not a_metadata.author.is_empty then
				author := a_metadata.author
			end
			keywords := a_metadata.keywords
			if not a_metadata.category.is_empty then
				category := a_metadata.category
			end
			if not a_metadata.license.is_empty then
				license := a_metadata.license
			end
		end

feature -- Output

	to_string: STRING
			-- Human-readable representation.
		do
			create Result.make (400)
			Result.append (name)
			if not version.is_empty then
				Result.append (" (")
				Result.append (version)
				Result.append (")")
			end
			if not description.is_empty then
				Result.append ("%N  ")
				Result.append (description)
			end
			if not author.is_empty then
				Result.append ("%N  Author: ")
				Result.append (author)
			end
			if not category.is_empty then
				Result.append ("%N  Category: ")
				Result.append (category)
			end
			if not keywords.is_empty then
				Result.append ("%N  Keywords: ")
				across keywords as kw loop
					if @kw.cursor_index > 1 then
						Result.append (", ")
					end
					Result.append (kw)
				end
			end
			if not license.is_empty then
				Result.append ("%N  License: ")
				Result.append (license)
			end
			if not dependencies.is_empty then
				Result.append ("%N  Dependencies: ")
				from
					dependencies.start
				until
					dependencies.after
				loop
					if dependencies.index > 1 then
						Result.append (", ")
					end
					Result.append (dependencies.item)
					dependencies.forth
				end
			end
			if is_installed then
				Result.append ("%N  [INSTALLED]")
			end
		end

	keywords_string: STRING
			-- Keywords as comma-separated string for search indexing.
		do
			create Result.make (100)
			across keywords as kw loop
				if not Result.is_empty then
					Result.append (" ")
				end
				Result.append (kw)
			end
		end

invariant
	name_not_empty: not name.is_empty or else name.is_empty -- Allow empty for error cases
	dependencies_exist: dependencies /= Void
	keywords_exist: keywords /= Void
	author_exists: author /= Void
	category_exists: category /= Void
	license_exists: license /= Void

end
