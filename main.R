library(tidyverse)
library(RMySQL)

download <- read_csv("download.csv")


con = dbConnect(MySQL(), user = 'root', password = '123456', dbname = 'mbiolance_cloud',host = '192.168.10.20')
dbListTables(con)


a <- lapply(download$run_id, function(x){
    sql <- paste0("update  k_experiment_seqdata set sample_type='child' where run_id = '",x,"'")
    res <- dbSendQuery(con, sql)
    message(sql)
})

filter2 <- read_csv("filter2.csv")

a <- lapply(filter2$run_id, function(x){
    sql <- paste0("update  k_experiment_seqdata set sample_type='child' where run_id = '",x,"'")
    res <- dbSendQuery(con, sql)
    message(sql)
})


res <- dbSendQuery(con, "SELECT * FROM k_experiment_seqdata")
dbFetch(res)


all_runs_metadata <- read_tsv("all_runs_metadata.tsv")

head(all_runs_metadata)
row1 <- all_runs_metadata[1,]
row1[grepl("NULL",row1)] <- " "
colnames(all_runs_metadata)
a <- lapply( c(1:nrow(all_runs_metadata)) ,function(x){
    row_data <- all_runs_metadata[x,]
    row_data[grepl("NULL",row_data)] <- " "
    # message(row_data['project_id'])
    sql <- paste0("insert into 
    k_experiment_seqdata (
        qcstatus, 
        bmi, 
        country, 
        disease, 
        experiment_type, 
        host_age, 
        instrument_model, 
        latitude, 
        longitude, 
        nr_reads_sequenced, 
        project_id, 
        run_id, 
        sex, 
        is_check
    )
    values
    (
        '",row_data['QCStatus'],"', 
        '",row_data['BMI'],"', 
        '",row_data['country'],"', 
        '",row_data['disease'],"', 
        '",row_data['experiment_type'],"', 
        '",row_data['host_age'],"', 
        '",row_data['instrument_model'],"', 
        '",row_data['latitude'],"', 
        '",row_data['longitude'],"', 
        '",row_data['nr_reads_sequenced'],"', 
        '",row_data['project_id'],"', 
        '",row_data['run_id'],"', 
        '",row_data['sex'],"', 
        0
    );")
    
    # message(sql)
    res <- dbSendQuery(con, sql)
})



