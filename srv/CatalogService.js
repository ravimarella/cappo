module.exports = cds.service.impl( async function(){

        const { EmployeeSet, POs} = this.entities;

        
        this.before('UPDATE', EmployeeSet, (req,res) => {
            console.log('SALARY UPDATE REQ:',req);
            if(parseFloat(req.data.salaryAmount)>100000){
                req.error(500,"Salary must be less than one hundred thousand");
            }
        });

        this.on('boost',async(req,res) => {
            console.log("BOOST REQUEST:",req);
            try{
                const ID=req.params[0];
                console.log("BOOSTING PO:"+ID);
                const tx = cds.tx(req);
                await tx.update(POs).with({
                    GROSS_AMOUNT:{'+=' : 20000},
                    NOTE:'Boosted!!'
                }).where(ID);
            }catch(error){
                return 'ERROR:',error.toString();
            }
        });

        this.on('largestOrder',async(req,res) => {
            try{
                console.log("LARGEST ORDER REQ----:",req.params);
                const ID= req.params[0];
                const tx =cds.tx(req);
                const reply = await tx.read(POs).orderBy({
                    GROSS_AMOUNT:'desc'
                }).limit(1);
                return reply;
            }
            catch(error){
                return "ERROR IN LARGEST ORDRE:",error.toString();
            }
        });


}

);
