#!/usr/bin/env nextflow
nextflow.enable.dsl=2 

process sayHello {
  input: 
   tuple val(id)
  output:
    stdout
  script:
    """
    echo '$id world!'
    """
}
process download{
    publishDir "output", mode: 'symlink'
    // debug true

    input:
        tuple val(id), val(fastq)
    output:
        tuple val(id), path("${id}/*.gz")
    script:
    if(fastq  instanceof List){
      StringBuilder sb = new StringBuilder();
      for (item in fastq){
          // sb.append("wget "+item.toUriString()+" -O ${id}/${item.fileName}\n")
          sb.append("touch ${id}/${item.fileName}\n")
      }
      // println("下载数据: "+id)

      """
          [ ! -d ${id} ] && mkdir ${id}
          ${sb}
      """
    }else{
      fastq0 = fastq.toUriString()
      // println("下载数据: "+id)
      """
          [ ! -d ${id} ] && mkdir ${id}
           
          # wget ${fastq0} -O ${id}/${fastq.fileName}
          touch ${id}/${fastq.fileName}
      """
    }
}

// include {reverse} from 'plugin/nf-amazon'
// include { fromQuery } from 'plugin/nf-sqldb'
workflow {
    // println channel
    // println Channel
    // channel.reverse('hi!').view()
    // println WorkflowMain.help()
    // csvData = file('download.csv').readLines()
    // sraList = []
    // // 处理 CSV 数据
    // for (line in csvData) {
    //     sraList.add(line.split(",")[1])
    // }
    // println sraList
    
    // ch = Channel.of2( 1, 3, 5, 7 )
    // ch.view()
    // ch.view { "value: $it" }
    // ch_sra = Channel.fromSRA(['SRR8924749', 'SRR6326268', 'ERR908505'],apiKey:'8145c95381a416f75f7f3245637414470807')
    // ch_sra.view()

    Channel
      .ofTweets("2", project: "id",valid:false).view()

// Channel
//   .ofTweets('nextflow', excludeRetweets: true)
//   .map { author, date_tweet -> author }
//   .collect()
//   .view()
    // ch = channel.watchTopic('analysis-ngs')
      // .subscribe { println "new message received ${it[0]}" }
    // ch.view()
    // Channel.of(
    //     "Hi folks",
    //     "Another message",
    //     "done"
    // ).view()
    // ch.map{[it[0],"aaa","aaa"]}.view()
    // ch.map{[it[0],"{'fastq1':'${it[1][0]}','fastq2':'{it[1][1]}','step':'QC' }"]}.publishTopic("ngs-analysis-result")

    // // println "111111111111"
    // sayHello(ch)
    // MD-13:/data/mrna/gaoyuan230708/ZF23052202-1/ZF23052202-1_1.fq.gz,/data/mrna/gaoyuan230708/ZF23052202-1/ZF23052202-1_2.fq.gz
    // ch = channel.fromTopic('liukang-test-topic')
    // ch.view()

    // ch_qu = channel.fromQuery('select run_id from k_experiment_seqdata where is_check =TRUE', db: 'foo').
    //   take(10)
    // ch_sra = ch_qu.
    //   fromSRA(apiKey:'8145c95381a416f75f7f3245637414470807')
    // download(ch_sra)
    //   .branch {
    //       pair: it[1].size()  ==2
    //       single: true
    //       // single: it instanceof List
    //   }
    //   .set { result }


    // result.pair
    //   .map(it -> tuple(it[1][0],it[1][1],"PAIRED", it[0]) )
    //   .sqlUpdate( into: 'k_experiment_seqdata', columns: 'fastq_1, fastq_2,library_layout',where:'run_id', db: 'foo' )
    // result.single
    //   .map(it -> tuple(it[1],"SINGLE", it[0]) )
    //   .sqlUpdate( into: 'k_experiment_seqdata', columns: 'fastq_1,library_layout',where:'run_id', db: 'foo' )

    // Channel
    //   .fromSRA(ch_acc.collect())
    // ch_qu.view()
    // download(ch_qu)
    // ch_qu
    //   .map( it -> tuple("aaa_1.fastq", "xxx_2.fastq",it[0]) )
    //   .sqlUpdate( into: 'k_experiment_seqdata', columns: 'fastq_1, fastq_2',where:'run_id', db: 'foo' )
    //   .view()


    // channel
    //   .of('Hello','world!')
    //   .map( it -> tuple(it, "test111",1) )
    //   .sqlUpdate( into: 'tags', columns: 'en_name, name',where:'id', db: 'foo' ).view()


 
    // ch_acc = Channel.fromPath( 'download.csv' )
    //         .splitCsv(skip: 1)
    //         .map {it[1] }
    // // ch_acc.view()

    // // println  ch_acc.collect().val()

 
    // ch_sra.view()
    // // result.small.view()

    // download(ch_sra)
    // ch_acc.collect().view()
    // ch_acc.view()
    // ch_acc.collect()
    // .view()
    // Channel
    //     .fromSRA(ch_acc.collect())
    //     .view()
    // Channel
    //     .fromSRA(ch_acc)
    //     .view()
    // ch_acc.view()
}