#'@title Prepare authorization cookie string
#'
#'@description This function is step by step process to create an auth cookie string for archive.org
#'Recommended to run this once and save the output as a named string. NB. Cookies expire, so this should be repeated regularly.
#'@keywords archive, waybackmachine
#'@export
#'@examples
#'cookies <- prepare_auth()



prepare_auth <- function() {
  message(
    "In order to utilise web cookie authorisation, it is necessary to copy cookies\n from an active web session.\n"
  )
  message("Please open a browser, and log into https://archive.org/account/login \n")
  message("If you do not have account, you will need to create one.\n")
  message("Once you are logged in, inspect the page and click on \"Application\" tab\n")
  message("Click on 'cookies' and copy the following cookie values to the input below:\n")
  login_user_cookie <- readline(prompt = "logged-in-user:")
  login_sig <- readline(prompt = "logged-in-sig:")
  cookies <-
    paste0('\"logged-in-sig=',
           login_sig,
           ';logged-in-user=',
           login_user_cookie,
           ';\"')
  return(cookies)
}


#'@title Wrapper for web.archive.org/save
#'
#'@description This function builds a command to save a specified URL to archive.org.
#'NB: it is recommended to have cookies saved as a string by running prepare_auth()
#'@param query_url A url string of a page that is to be archived
#'@param cookies A cookie string created by prepare_auth()
#'@keywords archive, waybackmachine
#'@export
#'@examples
#'pass_query(query_url = "https://cnn.com", cookies = cookies)

pass_query <- function(query_url, cookies) {
  if (missing(cookies)) {
    cookies <- prepare_auth()
  }
  save_url <- "https://web.archive.org/save/"
  query <-
    paste0(
      'curl -X GET -H "Accept: application/json" --cookie ',
      cookies,
      " ",
      save_url,
      query_url,
      '/&capture_outlinks=1/&js_behavior_timeout=5'
    )
  system(query)
}


#'@title Save a list of urls to web.archive.org
#'
#'@description This function interates through a list of url strings to save to archive.org.
#'NB: it is recommended to have cookies saved as a string by running prepare_auth()
#'@param url_list A list of url strings
#'@param cookies A cookie string created by prepare_auth()
#'@keywords archive, waybackmachine
#'@export
#'@examples

web_archive_list <- function(url_list, cookies) {
  require(purrr)

  if (missing(cookies)) {
    if (length(url_list) < 6) {
      cookies <- prepare_auth()
    } else{
      message("Please ensure that you provide a cookie string. See prepare_auth()")
    }
  }

  for (steps in seq(from = 1,
                    to = length(url_list),
                    by = 5)) {
    start <- steps
    end <-
      ifelse((steps + 4) > length(url_list), length(url_list), steps + 4)

    purrr::map(url_list[start:end], pass_query, cookies = cookies)
    Sys.sleep(45)
  }
}
