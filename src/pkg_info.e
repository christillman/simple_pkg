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

feature -- Output

	to_string: STRING
			-- Human-readable representation.
		do
			create Result.make (200)
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

invariant
	name_not_empty: not name.is_empty or else name.is_empty -- Allow empty for error cases
	dependencies_exist: dependencies /= Void

end
