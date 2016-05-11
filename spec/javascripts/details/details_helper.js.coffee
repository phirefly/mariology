@setupC2TestParams = ->
  {
    editMode: getEditModeContent(),
    formState: getRequestDetailsForm(),
    detailsForm: getRequestDetailsForm(),
    detailsSave: getRequestDetailsForm(),
    attachmentCard: getAttachmentContent(),
    actionBar: getActionBarContent(),
    undoCheck: getRequestDetailsForm(),
  }

@getEditModeContent = ->
  $('
    <div class="view-mode" id="mode-parent"></div>
  ')

@getAttachmentContent = ->
  $('
    <div class="card-for-attachments"></div>
  ')
  .html('
    <label for="attachment_file" class="attachment-label">file label</label>
      <form id="new_attachment">
        <input id="attachment_file" type="file">
        <button type="submit">
      </form>
      <ul class="attachment-list"></ul>
  ')

@getActionBarContent = ->
  $(
    '<div class="action-bar-template action-bar-wrapper">
      <ul id="request-actions">
        <li class="cancel-button">
          <button value="Cancel">
            <span>Cancel</span>
          </button>
        </li>
        <li class="save-button">
          <button value="Save">
            <span>Save</span>
          </button>
        </li>
      </ul>
    </div>'
  )

@getRequestDetailsForm = ->
  $('
    <div id="request-details-card">
      <form>
        <label>
          <input id="field_1">
        </label>
        <label>
          <input id="field_2">
        </label>
        <input id="submit" type="Submit">
      </form>
    </div>
  ')
