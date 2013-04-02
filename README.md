#merge-pool#

merge multi requests, process one and response all

## Install
	
	npm install git://github.com/neutra/merge-pool.git	

## Usage

	var echo = function(input,callback){
		var reply = function(){callback(null,input);};
		setTimeout(reply, 1000);
	};
	MergePool = require('merge-pool');
	MergePool.run('key',echo,1,console.log);
	MergePool.run('key',echo,2,console.log); 
	MergePool.run('another',echo,3,console.log);
	MergePool.run('key',echo,4,console.log);
	MergePool.run('another',echo,5,console.log);
	// null 1
	// null 1
	// null 1
	// null 3
	// null 3