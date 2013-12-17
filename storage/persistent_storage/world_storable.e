note
	description: "A class able to be stored in WORLD_STORAGE."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WORLD_STORABLE

inherit
	STORABLE

feature
    slug: NON_EMPTY_STRING
    		-- Some string that univocally identifies one object in the storage.

end
