class Demo2

 constructor: () ->
  $('.toggleable').hide()
  $('#start-demo').on 'click', () =>
   @uploadTags = []
   for tag in $("#upload-tags").val().trim().split(/\s*,\s*/)
    @uploadTags.push tag
   @reset()
   @uploadFiles()

 reset: () ->
  $(".toggleable").hide()

 uploadFiles: ->
  self = this
  infolinkClient.uploadFiles
   selector: "#file"
   tags: [@uploadTags]
   onStarted: (ev) =>
    self.reveal("#upload-progress")
    bar = Bootstrap.createProgressBar("file-#{ev.fileIdx}", '#upload-progress')
    bar.html($("<a>").css('color', 'white').html(ev.file.name))
   onProgress: (ev) ->
    Bootstrap.setProgressBar("file-#{ev.fileIdx}", ev.percent)
   onError: (ev) ->
    console.error ev
    notie.alert(3, 'Upload failed', 0.5)
    Bootstrap.getProgressBar("file-#{ev.fileIdx}").addClass('progress-bar-danger')
   onSuccess: (ev) ->
    bar = Bootstrap.getProgressBar("file-#{ev.fileIdx}")
    bar.addClass('progress-bar-success')
    $("a", bar).attr('href', ev.uri).append(" -> #{ev._id}")
   onComplete: (ev) ->
    notie.alert(1, 'Upload complete', 1.0)
    setTimeout () ->
     console.log ev
     self.identifySourcesAndClaims ev.uris
    , 1000

 reveal : (selector) ->
  $(selector).parents().show()

 identifySourcesAndClaims: (uris) ->
  notie.alert(2, 'Loading source and claim identification algorithm...', 7.5)
  self = this
  #infolinkClient.identifySourcesAndClaims uris,
  # execution:
  #  tags: @uploadTags
  # onStarted : (execution) ->
  #  console.log 'Started identification of sources and claims', execution
  #  self.reveal("#isac-progress")
  #  bar = Bootstrap.createProgressBar(execution._id, '#isac-progress')
  #  bar.html($("<a>").attr("href",execution.uri).append(execution._id))
  # onError: (execution) ->
  #  notie.alert(3, 'error', 0.5)
  # onProgress : (execution) ->
  #  Bootstrap.setProgressBar(execution._id, execution.progress)
  # onComplete : (execution) =>
  #  if execution.status is 'FAILED'
  #   console.error "Identification algorithm failed", execution
  #   notie.alert(6, 'Identification algorithm failed :(', 0.5)
  #   Bootstrap.getProgressBar(execution._id).addClass('progress-bar-danger')
  #   return
  #  notie.alert(1, 'Identification complete :)', 0.5)
  #  Bootstrap.getProgressBar(execution._id).addClass('progress-bar-success')
  #  self.reveal("#text-output-uri")
  #  for uri in execution.outputFiles
  #   $("#text-output-uri").append(
  #    $("<li>").append($("<a>").attr("href", uri).html(uri)))
  #  zebar = null
  #  infolinkClient.identifySourcesAndClaims execution.outputFiles,
  infolinkClient.identifySourcesAndClaims uris,
   execution:
    tags: @uploadTags
   onStarted : (execution) ->
    console.log 'Started source and claim extraction', execution
    self.reveal("#links")
    self.reveal("#isac-uri")
    self.reveal("#isac-progress")
    zebar = Bootstrap.createProgressBar('isac', '#isac-progress')
    zebar.html($("<a>").attr("href",execution.uri).append(execution._id))
   onError: (execution) ->
    notie.alert(3, 'ReportedSpeechTagger error', 0.5)
   onProgress : (exec) ->
    $("#isac-uri").html($("<a>").attr('href',exec.uri).text(exec.uri))
    Bootstrap.setProgressBar('isac', exec.progress).text(exec.progress)
   onComplete : (execution) ->
    if execution.status is 'FAILED'
     console.error "ReportedSpeechTagger failed", execution
     notie.alert(6, 'ReportedSpeechTagger failed :(', 0.5)
     Bootstrap.getProgressBar('isac').addClass('progress-bar-danger')
     return
    Bootstrap.setProgressBar('isac', 100)
    Bootstrap.getProgressBar('isac').addClass('progress-bar-success')
    notie.alert(1, 'ReportedSpeechTagger complete :)', 2.0)
    for uri in execution.links
     view = infolinkClient.createViewForUri(uri)

$ ->
 demo2 = new Demo2()
