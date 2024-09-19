const checkEnvs = (list) => {
  for (const val of list) {
    if (
      typeof process.env[val] == "undefined" ||
      process.env[val] === null ||
      (typeof process.env[val] == "string" && !process.env[val].trim())
    ) {
      throw new Error(`${val} Environment Value is not defined!`);
    }
  }
};
module.exports = {
  checkEnvs,
};
