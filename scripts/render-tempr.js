const stdin = process.stdin;
const stdout = process.stdout;

stdin.resume();
stdin.setEncoding("utf8");

let input = "";

const main = () => {
    let data = JSON.parse(input);

    const template = data.template;
    const renderer = require(`${data.renderer}/main`);

    const broker = {
        "consume": (exchange, consumer) => {
            consumer({
                "content": template,
                "ack": () => {},
                "nack": () => {},
            });
        },
        "publish": (exchange, routeKey, response) => {
            stdout.write(JSON.stringify({
                "rendered": response.rendered,
                "console": "", // TODO: Add console logging.
            }));
        }
    };

    const config = {};
    
    const logger = {
        "info": () => {},
        "error": () => console.error(msg),
    };

    renderer(broker, config, logger);
};

stdin.on("data", chunk => input += chunk);
stdin.on("end", main);
