const fs = require("fs");
const path = require("path");
const env = require("./env");


const addressKey = "<long-short-address>";

const preserveKeys = [
    "<network>",
    "<start-block>"
]

const prefix = env.openZeppelinDir;
const graphPath = "./graph";

const templateName = "subgraph.template.yaml";

const addAddress = (template, input) => {
    const address = (JSON.parse(input)).contracts.LongShort.address;
    return template.replace(addressKey, address);
}

const preserveValues = (template, output) => {
    templateLines = template.split('\n');
    outputLines = output.split('\n');
    preserveKeys.forEach(p => {
        const i = templateLines.findIndex((l) => l.includes(p));
        if(i != -1){
            templateVal = outputLines[i].split(":")[1].trim();
            template = template.replace(p, templateVal);
        }
    });
    return template;
}

Object.keys(env.openZeppelinToYaml).forEach(file => {
    let input, output, template;
    try{
        input = fs.readFileSync(path.join(prefix, file)).toString();
        template = fs.readFileSync(path.join(graphPath, templateName)).toString();
        output = fs.readFileSync(path.join(graphPath, env.openZeppelinToYaml[file])).toString();
    }catch(e){
        console.log(e);
        return;
    }
    template = addAddress(template, input);
    template = preserveValues(template, output);
    fs.writeFileSync(path.join(graphPath, env.openZeppelinToYaml[file]), template); 
})

