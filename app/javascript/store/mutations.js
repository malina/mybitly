export const state = {
  urls: []
}

export const mutations = {
  addOne (state, { data }) {
    state.urls = [data, ...state.urls]
  },

  addMany (state, { data }) {
    state.urls = [...data]
  }
}
