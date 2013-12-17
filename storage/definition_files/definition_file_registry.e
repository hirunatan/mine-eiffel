note
	description: "Summary description for {DEFINITION_FILE_REGISTRY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFINITION_FILE_REGISTRY

feature
    get_definition_file_for(type: STRING): DEFINITION_FILE
    do
        create Result.make
    end

end
