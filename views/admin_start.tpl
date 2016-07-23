<!DOCTYPE html>
<html>
    % include('head.tpl')
    <body>
        %include('nav_admin.tpl')
        <main class="new_ads">
            <div class="container">
                <h2>New ads</h2>
                %if ads:
                    %for ad in ads:
                    <a class="ad flexer_parent" href="/job/{{ad[0]}}">
                        <div class="content flexer">
                            %if ad[9]:
                                <div class="logo">
                                    <div class="img" style="background-image:url({{ad[9]}});"></div>
                                </div>
                            %end
                            <div class="text">
                                <h4>{{ad[3]}}</h4>
                                <p>{{ad[8]}}</p>
                            </div>
                            <div class="go"></div>
                        </div>
                    </a>
                    %end
                %else:
                    <p>Det finns inga nya annonser att godkänna</p>
                %end
            </div>
        </main>
        %include('footer.tpl')
    </body>
</html>
