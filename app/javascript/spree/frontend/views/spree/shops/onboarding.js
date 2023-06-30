function ImgUpload() {
  var imgWrap = "";
  var imgArray = [];

  $('.file-upload').each(function () {
    $(this).on('change', function (e) {
      imgWrap = $(this).closest('.upload__box');
      var maxLength = $(this).attr('data-max_length') || 10;

      var files = e.target.files;
      var filesArr = Array.prototype.slice.call(files);
      var iterator = 0;
      filesArr.forEach(function (f, _) {

        if (!f.type.match('image.*')) {
          return;
        }

        if (imgArray.length > maxLength) {
          return false
        } else {
          var len = 0;
          for (var i = 0; i < imgArray.length; i++) {
            if (imgArray[i] !== undefined) {
              len++;
            }
          }
          if (len > maxLength) {
            return false;
          } else {
            imgArray.push(f);

            var reader = new FileReader();
            reader.onload = function (e) {
              var html = "<div class='upload__img-box'><div data-number='" + $(".upload__img-close").length + "' data-file='" + f.name + "' class='img-bg'><img src=" + e.target.result + " data-file='" + f.name + "' class='upload__img' /><div class='upload__img-close'></div></div></div>";
              imgWrap.append(html);
              iterator++;
            }
            reader.readAsDataURL(f);
          }
        }
      });


      const newFileInput = $(this).clone();
      newFileInput.attr('name', 'product[variant_images_files][]');
      $('#variant_images_files').append(newFileInput);
    });
  });

  $('body').on('click', ".upload__img-close", function (e) {
    var file = $(this).parent().data("file");


    for (var i = 0; i < imgArray.length; i++) {
      if (imgArray[i].name === file) {
        imgArray.splice(i, 1);
        break;
      }
    }
    $('#variant_images_files').find(`[data-file="${file}"]`).attr('name', 'product[variant_images_files_remove][]');
    $(this).parent().parent().remove();
  });
}
Spree.ready(function() {
  ImgUpload();

  if ($('input[name="product[shipping_category_id]"]')) {
    if ($('input[name="product[shipping_category_id]"]:checked').data('name') == 'Default' || $('input[name="product[shipping_category_id]"]:checked').data('name') == 'Physical') {
      $('.shipping-panel').removeClass('d-none');
    } else {
      $('.shipping-panel').addClass('d-none');
    }

    $('input[name="product[shipping_category_id]"]').on('change', function(e) {
      if (e.target.dataset.name == 'Default' || e.target.dataset.name == 'Physical') {
        $('.shipping-panel').removeClass('d-none');
      } else {
        $('.shipping-panel').addClass('d-none');
      }
    });
  }
});