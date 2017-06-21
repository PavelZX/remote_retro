const user = (state = [], action) => {
  switch (action.type) {
    case "SET_USERS":
      return action.users
    case "UPDATE_USER":
      const { userToken, newAttributes } = action
      return state.map(user => (user.token === userToken ? { ...user, ...newAttributes } : user))
    default:
      return state
  }
}

export default user
