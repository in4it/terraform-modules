const pad = (num) => {
    return String(num).padStart(2, '0')
}

const sleep = (sec) => {
    return new Promise(resolve => setTimeout(resolve, sec));
}

const getExportStatus = async (taskId,cloudwatchlogs) => {
    try {
        const res = await cloudwatchlogs.describeExportTasks({ taskId: taskId }).promise();
        return res.exportTasks[0].status.code;
    } catch (error) {
        const err = `[X] ERROR describing task ${taskId}::: ${error}`;
        throw new Error(err);
    }
}
const calcPrefix = (prefix, name, day) => {
    return `${prefix}/${name}/${day.getUTCFullYear()}/${pad(day.getUTCMonth() + 1)}/${pad(day.getUTCDate())}/exportedlogs`
}

const checkEnvs = (list) => {
    for (const val of list) {
        if (typeof process.env[val] == 'undefined' || process.env[val] === null || (typeof process.env[val] == 'string' && !process.env[val].trim())) {
            throw new Error(`${val} Environment Value is not defined!`);
        }
    }
}
module.exports = {
    pad,
    sleep,
    getExportStatus,
    calcPrefix,
    checkEnvs
}