<!DOCTYPE html>
<html>
    %include('head.tpl')
    <body>
        %include('nav.tpl')
        <div class="login">
            <div class="container">
                <h1>New password</h1>
                <p>Type your new password:</p>
                <form name="reset_password" id="reset_password" method="post" action="/set_new_password">
                    <label for="password_one">New password</label>
                    <input placeholder="New password" type="password" name="password_one" id="password_one" value="">
                    <label for="password_two">New password again</label>
                    <input placeholder="New password again" type="password" name="password_two" id="password_two" value="">
                    <input class="btn submit red" type="submit" id="log_in_button" value="Change password">
                    <input type="input" style="display:none" name="page_url" value="{{page_url}}">
                    <p id="error"></p>
                </form>
            </div>
        </div>
        %include('footer.tpl')
    </body>
</html>
