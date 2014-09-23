class ImageInspect
  el: null
  inspect: null

  template: """
    <div id="cs-utils-imageinspect">
      <div class="image-container"></div>
    </div>
  """

  attachPoint: 'center center body center center'
  viewing: false

  width: 400
  height: 400

  constructor: (@inspect, params) ->
    @[key] = value for key, value of params

    document.body.insertAdjacentHTML 'beforeend', @template
    @el = document.querySelector '#cs-utils-imageinspect'
    
    @imageContainer = @el.querySelector '.image-container'

    @image = new Image
    @image.src = @inspect.src

    @imageContainer.style.backgroundImage = "url(#{ @inspect.src })"

    @el.style.width = "#{ @width }px"
    @el.style.height = "#{ @height }px"
    @imageContainer.style.width = "#{ @width }px"
    @imageContainer.style.height = "#{ @height }px"

    @attach()

    @inspect.addEventListener 'mouseover', @onMouseOver
    @inspect.addEventListener 'mouseout', @onMouseOut
    @inspect.addEventListener 'mousemove', @onMouseMove

  attach: =>
    attachPoint = @attachPoint.split ' '

    # Probably a still stuff wrong with this part
    for i in [0, 1, 3, 4]
      continue unless attachPoint[i] in ['left', 'center', 'right', 'top', 'bottom']
      switch attachPoint[i]
        when 'left', 'top'
          attachPoint[i] = 0
        when 'center' then attachPoint[i] = 0.5
        when 'right', 'bottom'
          attachPoint[i] = 1

    rect = document.querySelector("#{ attachPoint[2] }").getBoundingClientRect()

    left = rect.left + (rect.width * +attachPoint[3])
    top = rect.top + (rect.height * +attachPoint[4])

    @el.style.left = "#{ left }px"
    @el.style.top = "#{ top }px"

  onMouseOver: (e) =>
    @attach()

    @viewing = true
    @el.style.display = 'block'

  # Probably a better way of doing this
  onMouseMove: (mE) =>
    return unless @viewing

    inspectRect = @inspect.getBoundingClientRect()
    offsetX = mE.pageX - inspectRect.left
    offsetY = mE.pageY - inspectRect.top

    ratioX = offsetX / inspectRect.width
    ratioY = offsetY / inspectRect.height

    naturalXPosition = ratioX * @image.naturalWidth
    naturalYPosition = ratioY * @image.naturalHeight

    naturalXCenterOffset = naturalXPosition - @image.naturalWidth / 2
    naturalYCenterOffset = naturalYPosition - @image.naturalHeight / 2

    # Center the image, then apply the offset
    position = [(@width / 2) - (@image.naturalWidth / 2) - naturalXCenterOffset, (@height / 2) - (@image.naturalHeight / 2) - naturalYCenterOffset]

    @imageContainer.style.backgroundPosition = "#{ position[0] }px #{ position[1] }px"

  onMouseOut: (e) =>
    @viewing = false
    @el.style.display = 'none'

module?.exports = ImageInspect
window?.ImageInspect = ImageInspect
