#!/usr/bin/env nextflow
nextflow.enable.dsl=2 

process sayHello {
  input: 
    val x
  output:
    stdout
  script:
    """
    echo '$x world!'
    """
}
process download{
    publishDir "output", mode: 'symlink'
    input:
        tuple val(id), path(path)
    output:
        path("output/*")
    script:
    println path.size()
    """
        [ ! -d output ] && mkdir output
        touch output/${id}
    """
}

workflow {
    csvData = file('download.csv').readLines()
    sraList = []
    // 处理 CSV 数据
    for (line in csvData) {
        sraList.add(line.split(",")[1])
        // println(line.split(",")[1])
    }
    // println list
    ch_acc = Channel.fromPath( 'download.csv' )
            .splitCsv(skip: 1)
            .map {it[1] }
    // ch_acc.view()

    // println  ch_acc.collect().val()
    // ids = ['SRR8924749', 'SRR6326268 ', 'ERR908505']
    ch_sra = Channel
        .fromSRA(sraList,apiKey:'8145c95381a416f75f7f3245637414470807')
    ch_sra.view()
    // result.small.view()

    download(ch_sra)
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