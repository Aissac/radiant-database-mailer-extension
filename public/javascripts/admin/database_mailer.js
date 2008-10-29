document.observe("dom:loaded", function () {
  var element = $('expander');
  element.observe('click', function() {
    if (element.up('#filtering').hasClassName('expanded')) {
      hideForm()
    } else {
      showForm()
    }
   });
});

function hideForm() {
  Effect.SlideUp('form',{ duration: 0.5, afterFinish:function() {
    $('expander').up('#filtering').removeClassName('expanded')
    }
  });
}

function showForm () {
  $('expander').up('#filtering').addClassName('expanded')
    Effect.SlideDown('form', { duration: 0.5 });
}

function close() {
  if ($('expander').up('#filtering').hasClassName('expanded')) {
    hideForm()
  }
}