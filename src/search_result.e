note
	description: "[
		Search result from FTS5 package search.

		Contains:
		- Package name and description
		- Snippet with highlighted matches
		- BM25 relevance rank
		- Category for filtering
		- Link to full PKG_INFO if available
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SEARCH_RESULT

create
	make

feature {NONE} -- Initialization

	make (a_name, a_description, a_snippet: STRING; a_rank: REAL_64)
			-- Create search result.
		require
			name_not_empty: not a_name.is_empty
		do
			name := a_name
			description := a_description
			snippet := a_snippet
			rank := a_rank
			create category.make_empty
		ensure
			name_set: name.same_string (a_name)
			description_set: description.same_string (a_description)
			snippet_set: snippet.same_string (a_snippet)
			rank_set: rank = a_rank
		end

feature -- Access

	name: STRING
			-- Package name

	description: STRING
			-- Package description

	snippet: STRING
			-- Search snippet with highlighted matches (e.g., "<b>json</b> parser")

	rank: REAL_64
			-- BM25 relevance score (lower is better in SQLite FTS5)

	category: STRING
			-- Package category

	package: detachable PKG_INFO
			-- Full package info if available

feature -- Computed

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

	relevance_percent: INTEGER
			-- Relevance as percentage (0-100).
			-- BM25 scores are negative, closer to 0 is better.
		do
			-- Convert BM25 score to percentage
			-- Typical BM25 scores range from -25 (excellent) to 0 (poor match)
			Result := (100 + (rank * 4).truncated_to_integer).max (0).min (100)
		ensure
			valid_range: Result >= 0 and Result <= 100
		end

feature -- Modification

	set_category (a_category: STRING)
			-- Set category.
		do
			category := a_category
		ensure
			category_set: category.same_string (a_category)
		end

	set_package (a_package: PKG_INFO)
			-- Link to full package info.
		require
			package_not_void: a_package /= Void
		do
			package := a_package
		ensure
			package_set: package = a_package
		end

feature -- Output

	to_string: STRING
			-- Human-readable representation.
		do
			create Result.make (200)
			Result.append (name)
			if not category.is_empty then
				Result.append (" [")
				Result.append (category)
				Result.append ("]")
			end
			Result.append (" (")
			Result.append (relevance_percent.out)
			Result.append ("%% match)")
			if not snippet.is_empty then
				Result.append ("%N  ")
				Result.append (snippet)
			elseif not description.is_empty then
				Result.append ("%N  ")
				Result.append (description)
			end
		ensure
			result_not_empty: not Result.is_empty
		end

	to_compact_string: STRING
			-- Single-line representation for list display.
		do
			create Result.make (100)
			Result.append (name)
			Result.append (" - ")
			if not description.is_empty then
				if description.count > 60 then
					Result.append (description.substring (1, 57))
					Result.append ("...")
				else
					Result.append (description)
				end
			else
				Result.append ("(no description)")
			end
		ensure
			result_not_empty: not Result.is_empty
		end

invariant
	name_not_empty: not name.is_empty
	description_exists: description /= Void
	snippet_exists: snippet /= Void
	category_exists: category /= Void

end
