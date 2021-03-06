const stdin = process.stdin;
const stdout = process.stdout;

stdin.resume();
stdin.setEncoding("utf8");

let input = "";

const main = () => {
    const data = JSON.parse(input);

    const template = data.template;
    const renderer = require(`${data.renderer}/main`);

    const broker = {
        consume: (exchange, consumer) => {
            consumer({
                content: template,
                ack: () => {},
                nack: () => {}
            });
        },
        publish: (exchange, routeKey, response) => {
            stdout.write(
                JSON.stringify({
                    error: response.tempr.response && response.tempr.response.error,
                    rendered: response.tempr.rendered,
                    console: response.tempr.console,
                })
            );
        }
    };

    const config = {};

    const logger = {
        info: () => {},
        error: msg => console.error(msg)
    };

    renderer(broker, config, logger);
};

stdin.on("data", chunk => (input += chunk));
stdin.on("end", main);
