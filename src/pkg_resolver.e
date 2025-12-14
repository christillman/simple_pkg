note
	description: "[
		Package dependency resolver.

		Resolves transitive dependencies from ECF files.
		Builds a topologically sorted installation order.
		Detects circular dependencies.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	PKG_RESOLVER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize resolver.
		do
			create resolved.make (20)
			create visiting.make (20)
			create last_errors.make (5)
		end

feature -- Access

	resolved: ARRAYED_LIST [STRING]
			-- Resolved packages in installation order

	visiting: ARRAYED_LIST [STRING]
			-- Packages currently being visited (for cycle detection)

	last_errors: ARRAYED_LIST [STRING]
			-- Errors from resolution

	has_error: BOOLEAN
			-- Did resolution encounter errors?
		do
			Result := not last_errors.is_empty
		end

feature -- Resolution

	resolve_dependencies (a_package: PKG_INFO; a_registry: PKG_REGISTRY): ARRAYED_LIST [STRING]
			-- Resolve all dependencies for `a_package` in installation order.
			-- Returns list of package names (dependencies first, then package).
		require
			package_not_void: a_package /= Void
			registry_not_void: a_registry /= Void
		do
			resolved.wipe_out
			visiting.wipe_out
			last_errors.wipe_out

			resolve_recursive (a_package.name, a_registry)

			Result := resolved.twin
		ensure
			result_attached: Result /= Void
		end

	resolve_multiple (a_packages: ARRAY [STRING]; a_registry: PKG_REGISTRY): ARRAYED_LIST [STRING]
			-- Resolve dependencies for multiple packages.
		require
			packages_not_empty: not a_packages.is_empty
			registry_not_void: a_registry /= Void
		do
			resolved.wipe_out
			visiting.wipe_out
			last_errors.wipe_out

			across a_packages as name loop
				if not resolved.has (name) then
					resolve_recursive (name, a_registry)
				end
			end

			Result := resolved.twin
		ensure
			result_attached: Result /= Void
		end

feature {NONE} -- Implementation

	resolve_recursive (a_name: STRING; a_registry: PKG_REGISTRY)
			-- Recursively resolve dependencies using depth-first search.
		require
			name_not_empty: not a_name.is_empty
		local
			l_package: detachable PKG_INFO
			l_normalized: STRING
		do
			l_normalized := a_name.as_lower
			if l_normalized.starts_with ("simple_") then
				-- Already normalized
			else
				l_normalized := "simple_" + l_normalized
			end

			-- Skip if already resolved
			if resolved.has (l_normalized) then
				-- Already processed
			elseif visiting.has (l_normalized) then
				-- Circular dependency detected
				last_errors.extend ("Circular dependency detected: " + l_normalized)
			else
				-- Mark as visiting
				visiting.extend (l_normalized)

				-- Fetch package info
				l_package := a_registry.fetch_package (l_normalized)

				if attached l_package as pkg then
					-- Resolve dependencies first (depth-first)
					across pkg.dependencies as dep loop
						resolve_recursive (dep, a_registry)
					end
				end

				-- Remove from visiting, add to resolved
				visiting.prune_all (l_normalized)
				resolved.extend (l_normalized)
			end
		end

invariant
	resolved_exists: resolved /= Void
	visiting_exists: visiting /= Void

end
