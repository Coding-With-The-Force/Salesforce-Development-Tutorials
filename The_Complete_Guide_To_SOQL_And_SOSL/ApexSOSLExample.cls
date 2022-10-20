public class ApexSOSLExample {
    public static void soslExample(){
        List<List<SObject>> soslResults = [FIND 'Taco' IN ALL FIELDS 
                                           RETURNING Account(Id, Name), Contact(Id, Name)];
        System.debug('Results ::: ' + soslResults);
        for(List<SObject> objList: soslResults){
            for(SObject obj: objList){
                System.debug('This is our object ::: ' + obj);
            }
        }
    }
    
    public static void dynamicSoslExample(){
        String queryString = 'FIND \'Taco\' IN ALL FIELDS RETURNING Account(Id, Name), Contact(Id, Name)';
        List<List<SObject>> soslResults = search.query(queryString);
        for(List<SObject> objList: soslResults){
            for(SObject obj: objList){
                System.debug('This is our object ::: ' + obj);
            }
        }
    }
}