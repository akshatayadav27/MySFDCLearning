public class Challenge_One 
{
    public Static Void CategoriesAndRespectivePosts()
    {
        Map<String,List<String>> categoriesPostsMap = new Map<String,List<String>>();
        
        categoriesPostsMap.put('Apex', new List<String>{'Learn about new features that make the Salesforce release notes easier to use.','Read about changes to the release notes, with the most recent changes first.'});
        categoriesPostsMap.put('Lightning', new List<String>{'Check out what’s new in deployment.','Compose intelligent workflows with Flow Builder and Flow Orchestration.'});
        
        Set<String> categories = categoriesPostsMap.keyset();
        System.debug(categories);
        
        /* values return a List that contains all the values in the Map
          
			Illegal assignment from List<List<String>> to List<String>

			List<String> relatedPosts = categoriesPostsMap.values();
         */
        List<List<String>> relatedPosts = categoriesPostsMap.values();
        System.debug(relatedPosts);
        
        for(String iterator : categoriesPostsMap.keyset())
        {
            List<String> posts = categoriesPostsMap.get(iterator);
            system.debug('Category is :'+iterator+ 'And their respective Posts are :'+posts);
        }        
    }  
}