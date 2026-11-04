import { LitElement, html } from 'https://cdn.jsdelivr.net/gh/lit/dist@3/core/lit-core.min.js';

class SearchModal extends LitElement {
  createRenderRoot() {
    return this;
  }

  handleSearch(e) {
    const modalElement = document.getElementById('searchModal');
    bootstrap.Modal.getInstance(modalElement).hide();
  }

  firstUpdated() {
    const modalElement = this.querySelector('#searchModal');
    modalElement.addEventListener('shown.bs.modal', () => this.querySelector('input[name="q"]')?.focus());
    modalElement.addEventListener('hide.bs.modal', () => {
      if (document.activeElement instanceof HTMLElement) {
        document.activeElement.blur();
      }

      requestAnimationFrame(() => modalElement.removeAttribute('aria-hidden'));
    });
  }

  render() {
    return html`
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#searchModal" aria-label="Search">
        <i class="fa-solid fa-magnifying-glass"></i>
      </button>
      <div class="modal fade" id="searchModal" tabindex="-1" role="dialog" aria-modal="true">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content bg-transparent border-0">
            <div class="modal-body">
              <form action="https://www.google.com/search" method="GET" @submit="${this.handleSearch}">
                <div class="input-group">
                  <input type="hidden" name="hl" value="ja" />
                  <input type="hidden" name="sitesearch" value="kinjouj.github.io" />
                  <input type="search" name="q" class="form-control rounded-2 py-4" placeholder="Search" data-bs-theme="dark" />
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    `;
  }
}

customElements.define('search-modal', SearchModal);
