const puppeteer = require('puppeteer');
const chalk = require('chalk')
require('dotenv').config()

const error = (text) => {
  console.log(chalk.redBright.bold(text))
  process.exit(1)
} 

// checking environment variables
process.env.url || error("didn't provided a pronote url in .env !");
process.env.username || error("didn't provided a pronote username in .env !");
process.env.password || error("didn't provided a pronote password in .env !");

(async () => {
  const browser = await puppeteer.launch({headless: true})
  const page = await browser.newPage()
  await page.goto(process.env.url, {waitUntil: 'networkidle0', timeout: 90000})
  .catch(e => {
    console.error(e)
    exit(1)
  })
  await page.type('#id_50', process.env.username)
  await page.type('#id_51', process.env.password)
  await page.click('#id_39')
  await new Promise(resolve => {
    page.on('response', res => {
      res.text().then(text => {
        if (text.includes("notificationsCommunication")) {
          res.json().then(json => {
            let notificationsCommunication = json.donneesSec._Signature_.notificationsCommunication
            let onglet = { 131: "discussions", 104: "others", 8: "informations" }
            response = {}
            notificationsCommunication.forEach(item => {
              response[onglet[item.onglet]] = item.nb
            })
            console.log(JSON.stringify(response))
          })
          resolve()
        }
      })
    }) 
  })
  await browser.close()
})();

