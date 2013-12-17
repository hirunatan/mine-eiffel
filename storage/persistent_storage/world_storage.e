note
	description: "Summary description for {WORLD_STORAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORLD_STORAGE

create
	make

feature -- Constructor

	make
		do
			last_error_message := ""
		end

feature -- Access

	store_object (object: WORLD_STORABLE)
			-- Store an object with all its contents into world storage.
		local
			file_name: STRING
			file: RAW_FILE
		do
			file_name := file_name_for_slug (object.slug)
			create file.make_open_write (file_name)
			file.independent_store (object)
			file.close
		end

	get_object_by_slug (slug: NON_EMPTY_STRING): detachable WORLD_STORABLE
			-- Retrieve an object with all its contents from world storage, if exists.
			-- If not exists (or the file is unreadable), return Void and stores a message.
		local
			file: detachable RAW_FILE
		do
			create file.make_with_name (file_name_for_slug (slug))
			if file.access_exists then
				create file.make_open_read (file_name_for_slug (slug))
				if attached {WORLD_STORABLE} file.retrieved as object then
					Result := object
					last_error_message := ""
				else
					Result := Void
					last_error_message := "Object file with slug '" + slug.to_string + "' is broken"
				end
			else
				Result := Void
				last_error_message := "Cannot find object with slug '" + slug.to_string + "'"
			end
		rescue
			if attached file and then file.is_open_read then
				file.close
			end
		end

feature -- Status

	last_error_message: STRING

feature {NONE} -- Configuration constants

	World_storage_dir: STRING = "data/world_storage/"

	Storage_file_extension: STRING = ".object"

feature {NONE} -- Implementation

	file_name_for_slug (slug: NON_EMPTY_STRING): STRING
		do
			Result := World_storage_dir + slug.to_string + Storage_file_extension
		end

	custom_exceptions: EXCEPTIONS
		once
			create Result
		end

end
