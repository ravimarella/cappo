const cds=require("@sap/cds");

const { employees } = cds.entities("anubhav.db.master");

const mysrvdemo = function(srv){

    srv.on("READ","ReadEmployeeSrv",async(req,res) => {
        var results = [];

       /* results.push({
            "ID":"339133284932432DFDF",
            nameFirst:"Ravikiran",
            nameLast:"MARELLA"
        });
        return results;*/

      //  results = await cds.tx(req).run(SELECT.from(employees).limit(10));
      //results = await cds.tx(req).run(SELECT.from(employees).where(e -> e.get("salaryAmount").gt(50000) ));
      
    //  const tx =SELECT.from (employees) .where `salaryAmount>${50000}`
      
    var whereCondition = req.data;
    var tx;
    if(whereCondition.hasOwnProperty("ID")){
        tx =SELECT.from (employees) .where(whereCondition);
    }else{
        tx = SELECT.from (employees).limit(1);
    }
    results = await cds.tx(req).run(tx);
     return results;
    });

    srv.on("CREATE","InsertEmployeeSrv",async(req,res) => {
        var dataSet=[];
        console.log("**************************TRYING TO INSERT******************************")
        let returnData = await cds.transaction(tx).run([
            INSERT.into(employees).entries(dataSet)
        ]).then((resolve,reject) => {
            if(typeof(resolve) !== undefined){
                return req.data;
            }else{
                req.error(500,"INSERT FAILED");
            }
        }).catch( err => {
            req.erro(500, "ERROR "+ err.toString());
        });

        return returnData;


    });
    srv.on("UPDATE","UpdateEmployeeSrv",async(req,res) => {
        

    });
    srv.on("DELETE","DeleteEmployeeSrv",async(req,res) => {
        
        var dataSet=[];var tx;
        let returnData = await cds.transaction(tx).run([
            DELETE.from(employees).where({ID:req.data.ID})
        ]).then((resolve,reject) => {
            if(typeof(resolve) !== undefined){
                return req.data;
            }else{
                req.error(500,"DELETE FAILED");
            }
        }).catch( err => {
            req.erro(500, "DELETE ERROR "+ err.toString());
        });

        return returnData;
    });


};

module.exports = mysrvdemo;

