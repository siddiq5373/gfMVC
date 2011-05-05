interface {
	/* read Functions */
	/* Finders */
	/*
		options = {maxresults, pageno, timeout, cacheName}
	*/
	public any function count();
	public any function countWhere();
	public any function exists(id);
	/*
	public any function findAll(
		string where,
		string order,
		string select,
		string include,
		string returnAs,
		struct options
	);
	*/
	
	public any function findAll();
	public any function findByKey(id);
	public any function findOne();
	public any function findWhere();
	public any function findAllWhere();
	public any function getAll();
	public any function get(id);
	public any function list();
	
	/* Dynamic Finders */
	// FindByFirstName(), FindByLastName  have to implement using the actual service layers
	// getAll{FirstName}, getAll{LastName}
	
	/* write Functions */
	public any function create();
	public any function new();
	public any function update();
	public any function delete();
	public any function deleteByKey(string id);
	public any function deleteAll();
	public any function save();
	
	/* events are optional */
	/*
	public any function preInsert();
	public any function postInsert();
	public any function preUpdate();
	public any function postUpdate();
	public any function preSave();
	public any function postSave();
	public any function preDelete();
	public any function postDelete();
	*/

}