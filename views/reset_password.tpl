<!DOCTYPE html>
<html>
    %include('head.tpl')
    <body>
        %include('nav.tpl')
        <div class="login">
            <div class="container">
                <h1>Reset password</h1>
                <p>Type in the email for your accont:</p>
                <form name="reset_email" id="reset_email" method="post" action="/reset_password_email">
                    <label for="email">Mail</label>
                    <input placeholder="Email" type="input" name="email" id="email" value="">
                    <input class="btn submit red" type="submit" id="log_in_button" value="Send email">
                    <p id="error"></p>
                </form>
            </div>
        </div>
        %include('footer.tpl')
    </body>
</html>
