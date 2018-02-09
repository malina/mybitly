<template lang="pug">
  .page-container
    md-app md-mode="reveal"
      md-app-toolbar.md-primary
        span.md-title My Bitly
      md-app-content
        url-form
        br
        md-table(md-card="" md-sort="name" md-sort-order="asc" v-model="urls")
          md-table-toolbar
            h1.md-title Urls
          md-table-row(slot="md-table-row" slot-scope=("{ item }"))
            md-table-cell(md-label="ID" md-numeric="") {{ item.id }}
            md-table-cell(md-label="Name" md-sort-by="short_url") {{ item.short_url }}
            md-table-cell(md-label="Name" md-sort-by="original_url") {{ item.original_url }}
            md-table-cell(md-label="Name" md-sort-by="views") {{ item.views }}
</template>

<script>
import axios from 'axios'
export default {
  computed: {
    urls () {
      return this.$store.state.urls
    }
  },
  mounted: function () {
    axios.get('/v1/urls')
      .then(({ data }) => {
        this.$store.commit('addMany', { data })
      })
      .catch(error => {
        console.log(error);
      });
  }
}
</script>

<style scoped>
  .page-container {
    height: 100%
  }

  md-app-content {
    height: 100%
  }
</style>
