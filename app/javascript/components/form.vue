<template>
  <div>
    <form novalidate class="md-layout">
      <md-card class="md-layout-item md-size-50 md-small-size-100">
        <md-card-header>
          <div class="md-title">Create short link</div>
        </md-card-header>

        <md-card-content v-if="!haveUID">
          <md-field :class="messageClass">
            <label for="original_url">Insert Url</label>
            <md-textarea name="original_url" id="original_url" v-model="url.original_url" :disabled="sending" @input="debounceInput"></md-textarea>
          </md-field>
        </md-card-content>

        <md-card-content v-if="haveUID">
          <md-field>
            <label for="original_url">Url</label>
            <md-textarea name="original_url" id="original_url" v-model="url.original_url" :disabled="true"></md-textarea>
          </md-field>
          <md-field>
            <label for="url">http://mybitly.com/</label>
            <md-textarea name="url" id="url" v-model="url.url" :disabled="sending" @input="clearError"></md-textarea>
            <span class="md-helper-text" v-if="error"> {{error}} </span>
          </md-field>
        </md-card-content>

        <md-progress-bar md-mode="indeterminate" v-if="sending" />

        <md-card-actions>
          <md-button class="md-primary" :disabled="sending" @click="create">Create</md-button>
        </md-card-actions>
      </md-card>
    </form>
  </div>
</template>

<script>
  import debounce from 'debounce';
  import axios from 'axios'
  export default {
    name: 'url-form',
    data: () => ({
      url: {
        original_url: null,
        views: 0,
        url: null,
        short_url: null
      },
      sending: false,
      haveUID: false,
      invalidUrl: false,
      error: ''
    }),
    computed: {
      messageClass () {
        return {
          'md-invalid': this.invalidUrl
        }
      }
    },

    mounted() {
      console.log(this.$root);
    },
    methods: {
      debounceInput: debounce(function (e) {
        this.invalidUrl = false;
        if (e && e.length < 5) {
          return
        }
        axios.get('/v1/urls/new', {
          params: {
            'url[original_url]': e
          }
        }).then(({ data }) => {
            this.url = data;
            this.url.original_url = e;
            this.haveUID = true;
          })
          .catch(error => {
            this.invalidUrl = true;
            this.haveUID = false;
          });
      }, 300),

      reset() {
        this.url = {
          original_url: null,
          views: 0,
          url: null,
          short_url: null
        };
        this.sending = false;
        this.haveUID = false;
        this.invalidUrl = false;
        this.error = '';
      },
      clearError() {
        this.invalidUrl = false;
        this.error = '';
      },
      create () {
        this.sending = true
        let url = this.url
        axios.post('/v1/urls', { url })
        .then(({ data }) => {
          this.$store.commit('addOne', { data })
          this.reset();
        })
        .catch((error) => {
          this.sending = false;
          let url = error.response.data.errors.url;
          if (url) {
            this.invalidUrl = false;
            this.error = url.join(', ');
          }
        });
      }
    }
  }
</script>

<style lang="scss" scoped>
  .md-progress-bar {
    position: absolute;
    top: 0;
    right: 0;
    left: 0;
  }
</style>
