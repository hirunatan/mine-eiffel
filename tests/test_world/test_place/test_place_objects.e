note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_PLACE_OBJECTS

inherit

	EQA_TEST_SET

feature -- Test routines

	test_make_objects
		note
			testing: "covers/{PLACE_OBJECTS}.make"
		local
			place_objects: PLACE_OBJECTS
		do
			create place_objects.make
		end

	test_add_remove_object
		note
			testing: "covers/{PLACE_OBJECTS}.extend", "covers/{PLACE_OBJECTS}.prune", "covers/{PLACE_OBJECTS}.new_cursor"
		local
			place_objects: PLACE_OBJECTS
			count: INTEGER
		do
			create place_objects.make
			place_objects.extend (create {PLACE_OBJECT}.make("test_object", 50, 3, 0, 0, "some description"))
			across place_objects as pdc loop count := count + 1 end
			assert("iteration correct", count = 1)
			place_objects.prune (place_objects[1])
		end

	test_visible_objects
		note
			testing: "covers/{PLACE_OBJECTS}.visible_objects"
		local
			place_objects: PLACE_OBJECTS
			visible_objects: LIST [PLACE_OBJECT]
		do
			create place_objects.make
			place_objects.extend (create {PLACE_OBJECT}.make("test_object_1", 10, 1, 10, 0, "visible test object"))
			place_objects.extend (create {PLACE_OBJECT}.make("test_object_2", 10, 1, 40, 0, "invisible test object"))
			visible_objects := place_objects.visible_objects (20)
		end

	-- TODO: make tests for other methods of world logic
end
