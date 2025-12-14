note
	description: "[
		Semantic version handling for packages.

		Supports:
		- Parsing version strings (1.2.3)
		- Comparing versions
		- Checking compatibility
		- Parsing package@version syntax
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	PKG_VERSION

inherit
	COMPARABLE
		redefine
			is_equal
		end

create
	make,
	make_from_string,
	make_main

feature {NONE} -- Initialization

	make (a_major, a_minor, a_release: INTEGER)
			-- Create version with components.
		require
			non_negative: a_major >= 0 and a_minor >= 0 and a_release >= 0
		do
			major := a_major
			minor := a_minor
			release := a_release
			create tag.make_empty
		ensure
			major_set: major = a_major
			minor_set: minor = a_minor
			release_set: release = a_release
		end

	make_from_string (a_version: STRING)
			-- Parse version string like "1.2.3" or "v1.2.3".
		require
			version_not_empty: not a_version.is_empty
		local
			l_clean: STRING
			l_parts: LIST [STRING]
		do
			create tag.make_empty

			-- Remove 'v' prefix if present
			if a_version.starts_with ("v") or a_version.starts_with ("V") then
				l_clean := a_version.substring (2, a_version.count)
			else
				l_clean := a_version
			end

			-- Handle "main" or "master" branch names
			if l_clean.same_string ("main") or l_clean.same_string ("master") then
				major := 0
				minor := 0
				release := 0
				tag := l_clean
			else
				-- Parse semantic version
				l_parts := l_clean.split ('.')
				if l_parts.count >= 1 and then l_parts.i_th (1).is_integer then
					major := l_parts.i_th (1).to_integer
				end
				if l_parts.count >= 2 and then l_parts.i_th (2).is_integer then
					minor := l_parts.i_th (2).to_integer
				end
				if l_parts.count >= 3 and then l_parts.i_th (3).is_integer then
					release := l_parts.i_th (3).to_integer
				end
			end
		end

	make_main
			-- Create version representing "main" branch.
		do
			major := 0
			minor := 0
			release := 0
			create tag.make_from_string ("main")
		ensure
			is_main: is_main_branch
		end

feature -- Access

	major: INTEGER
			-- Major version number

	minor: INTEGER
			-- Minor version number

	release: INTEGER
			-- Release/patch version number

	tag: STRING
			-- Optional tag (e.g., "main", "alpha", "beta")

feature -- Status

	is_main_branch: BOOLEAN
			-- Is this the "main" or "master" branch?
		do
			Result := tag.same_string ("main") or tag.same_string ("master")
		end

	is_valid: BOOLEAN
			-- Is this a valid version?
		do
			Result := is_main_branch or else (major > 0 or minor > 0 or release > 0)
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current version less than `other`?
		do
			if major < other.major then
				Result := True
			elseif major = other.major then
				if minor < other.minor then
					Result := True
				elseif minor = other.minor then
					Result := release < other.release
				end
			end
		end

	is_equal (other: like Current): BOOLEAN
			-- Is current version equal to `other`?
		do
			Result := major = other.major and minor = other.minor and release = other.release
		end

	is_compatible_with (other: like Current): BOOLEAN
			-- Is current version API-compatible with `other`?
			-- Uses semantic versioning rules: same major version = compatible.
		do
			if is_main_branch or other.is_main_branch then
				Result := True  -- Main branch is always "compatible"
			else
				Result := major = other.major
			end
		end

	satisfies (a_constraint: STRING): BOOLEAN
			-- Does this version satisfy the constraint?
			-- Supports: "1.2.3" (exact), "^1.2" (compatible), ">=1.0" (minimum)
		local
			l_other: PKG_VERSION
		do
			if a_constraint.starts_with ("^") then
				-- Compatible version (same major)
				create l_other.make_from_string (a_constraint.substring (2, a_constraint.count))
				Result := is_compatible_with (l_other) and Current >= l_other
			elseif a_constraint.starts_with (">=") then
				-- Minimum version
				create l_other.make_from_string (a_constraint.substring (3, a_constraint.count))
				Result := Current >= l_other
			elseif a_constraint.starts_with (">") then
				-- Greater than
				create l_other.make_from_string (a_constraint.substring (2, a_constraint.count))
				Result := Current > l_other
			elseif a_constraint.starts_with ("<=") then
				-- Maximum version
				create l_other.make_from_string (a_constraint.substring (3, a_constraint.count))
				Result := Current <= l_other
			elseif a_constraint.starts_with ("<") then
				-- Less than
				create l_other.make_from_string (a_constraint.substring (2, a_constraint.count))
				Result := Current < l_other
			else
				-- Exact version
				create l_other.make_from_string (a_constraint)
				Result := is_equal (l_other)
			end
		end

feature -- Output

	to_string: STRING
			-- Version as string (e.g., "1.2.3").
		do
			if is_main_branch then
				Result := tag.twin
			else
				create Result.make (10)
				Result.append (major.out)
				Result.append (".")
				Result.append (minor.out)
				Result.append (".")
				Result.append (release.out)
				if not tag.is_empty and not is_main_branch then
					Result.append ("-")
					Result.append (tag)
				end
			end
		ensure
			result_not_empty: not Result.is_empty
		end

feature -- Parsing helpers

	parse_package_spec (a_spec: STRING): TUPLE [name: STRING; version: detachable PKG_VERSION]
			-- Parse "package@version" or "package" spec.
			-- Returns package name and optional version.
		local
			l_at_pos: INTEGER
			l_name, l_ver: STRING
		do
			l_at_pos := a_spec.index_of ('@', 1)
			if l_at_pos > 0 then
				l_name := a_spec.substring (1, l_at_pos - 1)
				l_ver := a_spec.substring (l_at_pos + 1, a_spec.count)
				Result := [l_name, create {PKG_VERSION}.make_from_string (l_ver)]
			else
				Result := [a_spec, Void]
			end
		ensure
			result_attached: Result /= Void
			name_not_empty: not Result.name.is_empty
		end

invariant
	non_negative_major: major >= 0
	non_negative_minor: minor >= 0
	non_negative_release: release >= 0
	tag_exists: tag /= Void

end
