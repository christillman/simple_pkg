note
	description: "[
		Lock file management for reproducible installations.

		Creates and reads .simple-lock.json files that record:
		- Exact versions of installed packages
		- Installation timestamps
		- Dependency tree

		Format:
		{
		  "locked_at": "2025-12-14T15:30:00Z",
		  "packages": {
		    "simple_json": { "version": "1.2.0", "path": "D:/prod/simple_json" },
		    "simple_http": { "version": "1.0.0", "path": "D:/prod/simple_http" }
		  }
		}
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	PKG_LOCK

create
	make,
	make_from_file

feature {NONE} -- Initialization

	make
			-- Create empty lock file.
		do
			create packages.make (20)
			create locked_at.make_empty
			create file_path.make_empty
		end

	make_from_file (a_path: STRING)
			-- Load lock file from path.
		require
			path_not_empty: not a_path.is_empty
		do
			create packages.make (20)
			create locked_at.make_empty
			file_path := a_path
			load
		end

feature -- Access

	file_path: STRING
			-- Path to lock file

	packages: HASH_TABLE [PKG_LOCK_ENTRY, STRING]
			-- Locked packages by name

	locked_at: STRING
			-- Timestamp when lock file was created/updated

	is_valid: BOOLEAN
			-- Is this a valid lock file?
		do
			Result := not packages.is_empty
		end

feature -- Queries

	has_package (a_name: STRING): BOOLEAN
			-- Is package locked?
		require
			name_not_empty: not a_name.is_empty
		do
			Result := packages.has (a_name)
		end

	package_version (a_name: STRING): detachable STRING
			-- Get locked version for package.
		require
			name_not_empty: not a_name.is_empty
		do
			if attached packages.item (a_name) as entry then
				Result := entry.version
			end
		end

	package_path (a_name: STRING): detachable STRING
			-- Get locked path for package.
		require
			name_not_empty: not a_name.is_empty
		do
			if attached packages.item (a_name) as entry then
				Result := entry.path
			end
		end

feature -- Modification

	add_package (a_name, a_version, a_path: STRING)
			-- Add or update package in lock.
		require
			name_not_empty: not a_name.is_empty
			version_not_empty: not a_version.is_empty
		local
			l_entry: PKG_LOCK_ENTRY
		do
			create l_entry.make (a_version, a_path)
			packages.force (l_entry, a_name)
		ensure
			has_package: has_package (a_name)
		end

	remove_package (a_name: STRING)
			-- Remove package from lock.
		require
			name_not_empty: not a_name.is_empty
		do
			packages.remove (a_name)
		ensure
			removed: not has_package (a_name)
		end

	clear
			-- Remove all packages from lock.
		do
			packages.wipe_out
		ensure
			empty: packages.is_empty
		end

feature -- Persistence

	save
			-- Save lock file to disk.
		require
			file_path_set: not file_path.is_empty
		local
			l_json: SIMPLE_JSON_OBJECT
			l_packages_json: SIMPLE_JSON_OBJECT
			l_entry_json: SIMPLE_JSON_OBJECT
			l_file: SIMPLE_FILE
			l_datetime: SIMPLE_DATE_TIME
		do
			-- Update timestamp
			create l_datetime.make_now_utc
			locked_at := l_datetime.to_iso8601_utc

			-- Build JSON
			create l_json.make
			l_json := l_json.put_string (locked_at, "locked_at")

			create l_packages_json.make
			across packages as pkg loop
				create l_entry_json.make
				l_entry_json := l_entry_json.put_string (pkg.version, "version")
				l_entry_json := l_entry_json.put_string (pkg.path, "path")
				l_packages_json := l_packages_json.put_object (l_entry_json, @pkg.key)
			end
			l_json := l_json.put_object (l_packages_json, "packages")

			-- Write to file
			create l_file.make (file_path)
			if l_file.write_all (l_json.to_pretty_json) then
				-- Success
			end
		end

	load
			-- Load lock file from disk.
		require
			file_path_set: not file_path.is_empty
		local
			l_file: SIMPLE_FILE
			l_json: SIMPLE_JSON
			l_content: STRING_32
			l_entry: PKG_LOCK_ENTRY
		do
			packages.wipe_out
			create l_file.make (file_path)

			if l_file.exists then
				l_content := l_file.content
				if not l_content.is_empty then
					create l_json
					if attached l_json.parse (l_content) as l_parsed and then l_parsed.is_object then
						-- Read timestamp
						if attached l_parsed.as_object.string_item ("locked_at") as l_ts then
							locked_at := l_ts.to_string_8
						end

						-- Read packages
						if attached l_parsed.as_object.object_item ("packages") as l_pkgs then
							across l_pkgs.keys as key loop
								if attached l_pkgs.object_item (key) as l_pkg_json then
									create l_entry.make (
										if attached l_pkg_json.string_item ("version") as v then v.to_string_8 else "main" end,
										if attached l_pkg_json.string_item ("path") as p then p.to_string_8 else "" end
									)
									packages.force (l_entry, key.to_string_8)
								end
							end
						end
					end
				end
			end
		end

feature -- Factory

	default_lock_file_name: STRING = ".simple-lock.json"
			-- Default lock file name

	create_for_directory (a_directory: STRING): PKG_LOCK
			-- Create lock file for directory.
		require
			directory_not_empty: not a_directory.is_empty
		local
			l_path: STRING
		do
			l_path := a_directory + "/" + default_lock_file_name
			create Result.make
			Result.set_file_path (l_path)
		ensure
			result_attached: Result /= Void
		end

feature -- Settings

	set_file_path (a_path: STRING)
			-- Set file path.
		require
			path_not_empty: not a_path.is_empty
		do
			file_path := a_path
		ensure
			file_path_set: file_path.same_string (a_path)
		end

feature -- Output

	to_string: STRING
			-- Human-readable representation.
		do
			create Result.make (500)
			Result.append ("Lock file: " + file_path + "%N")
			Result.append ("Locked at: " + locked_at + "%N")
			Result.append ("Packages: " + packages.count.out + "%N")
			across packages as pkg loop
				Result.append ("  " + @pkg.key + " @ " + pkg.version)
				if not pkg.path.is_empty then
					Result.append (" -> " + pkg.path)
				end
				Result.append ("%N")
			end
		end

invariant
	packages_exist: packages /= Void
	file_path_exists: file_path /= Void

end
