document.observe("dom:loaded", function () {
  var element = $('expander');
  element.observe('click', function() {
    if (element.up('#filters').hasClassName('expanded')) {
      hideForm()
    } else {
      showForm()
    }
  });
  center('blob-popup');
});

function hideForm() {
  Effect.SlideUp('form',{ duration: 0.5, afterFinish:function() {
    $('expander').up('#filters').removeClassName('expanded')
    }
  });
}

function showForm () {
  $('expander').up('#filters').addClassName('expanded')
    Effect.SlideDown('form', { duration: 0.5 });
}

function close() {
  if ($('expander').up('#filters').hasClassName('expanded')) {
    hideForm()
  }
}


document.observe("dom:loaded", function () {
  var element = $('x_expander');
  element.observe('click', function() {
    if (element.up('#x_filters').hasClassName('expanded')) {
      hideXForm()
    } else {
      showXForm()
    }
   });
});

function hideXForm() {
  Effect.SlideUp('x_form',{ duration: 0.5, afterFinish:function() {
    $('x_expander').up('#x_filters').removeClassName('expanded')
    }
  });
}

function showXForm () {
  $('x_expander').up('#x_filters').addClassName('expanded')
    Effect.SlideDown('x_form', { duration: 0.5 });
}

function closeX() {
  if ($('x_expander').up('#x_filters').hasClassName('expanded')) {
    hideXForm()
  }
}

function show_details() {
  $('attachments').hide();
  $('details').show();
  $('details_lnk').addClassName('here');
  $('attachments_lnk').removeClassName('here');  
}

function show_attachments() {
  $('attachments').show();
  $('details').hide();
  $('details_lnk').removeClassName('here');
  $('attachments_lnk').addClassName('here');
}