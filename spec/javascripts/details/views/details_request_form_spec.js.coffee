#= require jquery
#= require details/views/details_request_form
#= require spec_helper
#= require details/details_helper

describe 'DetailsRequestForm', ->
  
  describe '#_event', ->
    it "form keypress is triggered on input field", ->
      test_ran = false
      content = getRequestDetailsForm()
      form = new DetailsRequestFormState(content)  
      form._setup()
      first_field = content.find('input').first()
      form.el.on 'form:changed', ( ->
        test_ran = true
      )
      triggerKeyDown(first_field, 70)
      expect(test_ran).to.eql(true)
