note
	description: "Summary description for {DEFINITION_FILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFINITION_FILE

create
	make

feature -- Constructor

	make
		do
			last_error_message := ""
		end

feature
    retrieve_from_def (slug: STRING): WORLD_STORABLE
    do
		create {PLACE} Result.make
    end

feature -- Status
    last_error_message: STRING

end
