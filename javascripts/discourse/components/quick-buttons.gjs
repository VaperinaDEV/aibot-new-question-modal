import Component from "@glimmer/component";
import { fn } from "@ember/helper";
import { action } from "@ember/object";
import { service } from "@ember/service";
import concatClass from "discourse/helpers/concat-class";
import DButton from "discourse/components/d-button";

export default class QuickButtons extends Component {
  @service hiddenSubmit;

  @action
  updateAndSubmit(value) {
    this.hiddenSubmit.inputValue = value;
    this.hiddenSubmit.submitToBot();
  }

  get randomQuickLinks() {
    const shuffledLinks = settings.quick_links.slice().sort(() => Math.random() - 0.5);
    return shuffledLinks.slice(0, 5); // Limit to 5 buttons
  }

  @action
  didInsertElement() {
    this.checkScrollable();
  }

  checkScrollable() {
    const buttonWrapper = document.querySelector(".aibot-modal__button-wrapper");
    const threshold = 150;

    if (buttonWrapper) {
      console.log('Button wrapper found:', buttonWrapper);
      console.log('Button wrapper height:', buttonWrapper.offsetHeight);

      buttonWrapper.classList.toggle('scrollable', buttonWrapper.offsetHeight > threshold);
    } else {
      console.error('Button wrapper not found');
    }
  }

  get scrollableButtonWrapper() {
    const buttonWrapper = document.querySelector(".aibot-modal__button-wrapper");
    const threshold = 150;

    if (buttonWrapper) {
      return buttonWrapper.offsetHeight > threshold;
    }
  }

  <template>
    <div class="aibot-modal__button-wrapper {{if (this.scrollableButtonWrapper) 'scrollable'}}">
      {{#each this.randomQuickLinks as |link|}}
        <DButton
          @action={{fn this.updateAndSubmit link.question}}
          @translatedLabel={{link.question}}
          class={{concatClass
            "ai-question-button"
            settings.quick_buttons_style
          }}
        />
      {{/each}}
    </div>
  </template>
}
