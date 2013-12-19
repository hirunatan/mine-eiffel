note
	description: "A persistent storage for WORLD_STORABLE objects."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	WORLD_STORAGE

feature -- Access

	store_object (type: STRING; object: WORLD_STORABLE)
			-- Store an object of a type with all its contents into world storage.
		local
			file_name: STRING
			file: RAW_FILE
		do
				-- Currently the type is ignored
			file_name := file_name_for_slug (object.slug)
			create file.make_open_write (file_name)
			file.independent_store (object)
			file.close
		end

	retrieve_object_by_slug (type: STRING; slug: NON_EMPTY_STRING)
			-- Retrieve an object with all its contents from world storage, if stored.
			-- If not, try to create the object from a definition file, if exists.
			-- If the file does not exist (or is unreadable), return sets an error message.
		local
			file: detachable RAW_FILE
			registry: DEFINITION_FILE_REGISTRY
			definition_file: DEFINITION_FILE
		do
			create file.make_with_name (file_name_for_slug (slug))
			if file.access_exists then

				-- Retrieve object from storage
				file.open_read
				if attached {WORLD_STORABLE} file.retrieved as o then
					retrieved_object := o
					last_error_message := ""
				else
					retrieved_object := Void
					last_error_message := "Object file with slug '" + slug.to_string + "' is broken"
				end
				file.close
			else

				-- Create object from definition
				definition_file := registry.get_definition_file_for (type)
				definition_file.create_object_from_def (slug)
				if not definition_file.error_occurred then
					retrieved_object := definition_file.created_object
					last_error_message := ""
				else
					retrieved_object := Void
					last_error_message := definition_file.last_error_message
				end
			end
		rescue
			if attached file and then file.is_open_read then
				file.close
			end
		end

	retrieved_object: detachable WORLD_STORABLE
			-- The object if the last call to retrieve_object_by_slug was successful, or Void if not.

feature -- Status

	error_occurred: BOOLEAN
			-- True if the last call to retrieve_object_by_slug generated an error
			-- (or if it has not been called yet)
		do
			Result := not last_error_message.is_empty
		end

	last_error_message: STRING
			-- If error_occurred, here it is the message.
		attribute
			Result := "(still not called)"
		end

feature {NONE} -- Configuration constants

	World_storage_dir: STRING = "data/world_storage/"

	Storage_file_extension: STRING = ".object"

feature {NONE} -- Implementation

	file_name_for_slug (slug: NON_EMPTY_STRING): STRING
		do
			Result := World_storage_dir + slug.to_string + Storage_file_extension
		end

invariant
	no_object_if_error: error_occurred implies retrieved_object = Void
	object_if_not_error: (not error_occurred) implies retrieved_object /= Void

end
