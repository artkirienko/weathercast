import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
// Enable Stimulus debug mode in development
application.debug = false
window.Stimulus   = application

export { application }
