note
	description: "Single entry in a lock file representing an installed package."
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	PKG_LOCK_ENTRY

create
	make

feature {NONE} -- Initialization

	make (a_version, a_path: STRING)
			-- Create entry with version and path.
		require
			version_not_empty: not a_version.is_empty
		do
			version := a_version
			path := a_path
		ensure
			version_set: version.same_string (a_version)
			path_set: path.same_string (a_path)
		end

feature -- Access

	version: STRING
			-- Locked version (e.g., "1.2.0" or "main")

	path: STRING
			-- Installation path

feature -- Modification

	set_version (a_version: STRING)
			-- Set version.
		require
			version_not_empty: not a_version.is_empty
		do
			version := a_version
		ensure
			version_set: version.same_string (a_version)
		end

	set_path (a_path: STRING)
			-- Set path.
		do
			path := a_path
		ensure
			path_set: path.same_string (a_path)
		end

invariant
	version_exists: version /= Void
	path_exists: path /= Void

end
