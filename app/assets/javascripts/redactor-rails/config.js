$(document).ready(
  function(){
    var csrf_token = $('meta[name=csrf-token]').attr('content');
    var csrf_param = $('meta[name=csrf-param]').attr('content');
    var params;

    if (csrf_param !== undefined && csrf_token !== undefined) {
      params = csrf_param + "=" + encodeURIComponent(csrf_token);
    }

    var RedactorConfigs = {
      "imageUpload":"/redactor_rails/pictures?" + params,
      "imageGetJson":"/redactor_rails/pictures",
      "fileUpload":"/redactor_rails/documents?" + params,
      "fileGetJson":"/redactor_rails/documents",
      "path":"/assets/redactor-rails",
      "css":"style.css",
      "lang":"pt_br",
      "plugins": ["fontsize", "fontcolor", "fontfamily"]
    };

    $('.redactor').redactor(RedactorConfigs);
  }
);
