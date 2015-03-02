/* js placed at the end of the document so the pages load faster */
//= require jquery

//= require twitter/bootstrap

//= require plugins/moment
//
//= require plugins/hover-dropdown
//= require plugins/jquery.lazyload
//= require plugins/jquery.flexslider
//= require plugins/jquery.bxslider
//= require plugins/jquery.parallax-1.1.3
//= require plugins/jquery.easing.1.3
//= require plugins/link-hover
//= require plugins/jquery.fancybox
//= require plugins/jquery.themepunch.plugins.min
//= require plugins/jquery.themepunch.revolution

//= require home/common-scripts
//= require home/revolution-slide

RevSlide.initRevolutionSlider();

$(window).load(function() {
  // # Carregamento sobre demanda das imagens
  $("img.lazy").show().lazyload({
    threshold: 200,
    effect: "fadeIn"
  })

  $('[data-zlname = reverse-effect]').mateHover({
      position: 'y-reverse',
      overlayStyle: 'rolling',
      overlayBg: '#fff',
      overlayOpacity: 0.7,
      overlayEasing: 'easeOutCirc',
      rollingPosition: 'top',
      popupEasing: 'easeOutBack',
      popup2Easing: 'easeOutBack'
  });

  $('.flexslider').flexslider({
      animation: "slide",
      start: function(slider) {
          $('body').removeClass('loading');
      }
  });
});

//    fancybox
jQuery(".fancybox").fancybox();
