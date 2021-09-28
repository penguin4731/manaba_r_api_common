require 'selenium-webdriver'
require 'dotenv'

Dotenv.load

class ManabaManager
  def initialize
    @wait_time = 3
    @timeout = 4
    Selenium::WebDriver.logger.output = File.join("./", "selenium.log")
    Selenium::WebDriver.logger.level = :warn
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    @driver = Selenium::WebDriver.for :chrome, options: options
    @driver.manage.timeouts.implicit_wait = @timeout
    wait = Selenium::WebDriver::Wait.new(timeout: @wait_time)
  end

  def quit
    @driver.quit
  end

  def loginManaba
    # Manabaを開く → ログインページへ遷移
    @driver.get('https://ct.ritsumei.ac.jp/ct/home')
    sleep 2

    begin
      user_id_box = @driver.find_element(:id, 'User_ID') # ユーザーID
      password_box = @driver.find_element(:id, 'Password') # パスワード
      login_btn = @driver.find_element(:id, 'Submit') # ログインボタン
    rescue Selenium::WebDriver::Error::NoSuchElementError
      p 'no such element error!!'
      return
    end

    # ログインする
    user_id_box.send_keys ENV['MANABA_ID']
    password_box.send_keys ENV['MANABA_PASSWORD']
    login_btn.click

    # ログインするまで待つ
    sleep 1
  end

  def getTasks(task_id)
    tasks = []

    # 課題未提出サイトへ移動
    if task_id == 0
      @driver.get('https://ct.ritsumei.ac.jp/ct/home_summary_query')
    elsif task_id == 1
      @driver.get('https://ct.ritsumei.ac.jp/ct/home_summary_survey')
    elsif task_id == 2
      @driver.get('https://ct.ritsumei.ac.jp/ct/home_summary_report')
    else
      return
    end
    sleep 1

    begin
      contents_table = @driver.find_element(:class, 'stdlist')
      contents_trs = contents_table.find_elements(:tag_name, "tr")
      for i in (1..contents_trs.length-1)
        contents_tds = contents_trs[i].find_elements(:tag_name, "td")
        tasks.push(
          {
            'title': contents_tds[0].text,
            'deadline': Date.parse(contents_tds[2].text),
            'type': task_id,
            'url': contents_tds[0].find_element(:tag_name, 'a').attribute("href"),
            'className': contents_tds[1].text
          }
        )
      end
    rescue => exception
      p 'error: ' + exception
    end

    return tasks
  end
end
