<!--
Skriven av: Philip (HTML + CSS)
-->
<!DOCTYPE html>
<html>
    % include('head.tpl')
    <body>
        %include('nav.tpl')
            <div class="new_accont">
                <div class="container">
                    <h1>Create account</h1>
                    <p>You only need an account if you want to post a quest.</p>
                    <form name="create_user" id="create_user" method="post" action="/do_create_user">
                        <label for="first_name">First name</label>
                        <input placeholder="First name" type="input" name="first_name" id="first_name" value="" required>
                        <label for="last_name">Last name</label>
                        <input placeholder="Last name" type="input" name="last_name" id="last_name" value="" required>
                        <label for="phone">Phone</label>
                        <input placeholder="Phone" type="input" name="phone" id="phone" value="" required>
                        <label for="email">Mail</label>
                        <input placeholder="Mail" type="input" name="email" id="email" value="" required>
                        <label for="password">Password</label>
                        <input placeholder="Password" type="input" name="password" id="password" value="" required>
                        <input class="btn submit red" id="create_account" type="submit" value="Skapa konto">
                    </form>
                    <p id="error"></p>
                </div>
            </div>
        %include('footer.tpl')
    </body>
</html>
