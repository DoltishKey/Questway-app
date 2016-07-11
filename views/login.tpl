<!DOCTYPE html>
<html>
    %include('head.tpl')
    <body>
        %include('nav.tpl')
        <div class="login">
            <div class="container">
                <h1>Log in - entrepenures</h1>
                <p>If you want to apply for a quest you don´t have to login.</p>
                <form name="logIn" id="logIn" method="post" action="/do_login">
                    <label for="email">Mail</label>
                    <input placeholder="Email" type="input" name="email" id="email" value="">
                    <label for="password">Password</label>
                    <input placeholder="Password" type="password" name="password" id="password" value="">
                    <input class="btn submit red" type="submit" id="log_in_button" value="Log in">
                    <p id="error"></p>
                </form>
                <p><a href="#">Forgotten password?</a></p>
            </div>
        </div>
        %include('footer.tpl')
    </body>
</html>
