/* js placed at the end of the document so the pages load faster */
//= require jquery

//= require twitter/bootstrap

//= require plugins/moment
//= require plugins/pace
//= require plugins/jquery.lazyload


$(window).load(function() {
  // # Carregamento sobre demanda das imagens
  $("img.lazy").show().lazyload({
    threshold: 200,
    effect: "fadeIn"
  })
});
