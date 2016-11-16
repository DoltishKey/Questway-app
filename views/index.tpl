<!DOCTYPE html>
<html>
    % include('head.tpl')
    <body>
        %if user_lvl == 1:
            %include('nav_admin.tpl')
        %elif user_lvl == 2:
            %include('nav_employers.tpl')
        %else:
            %include('nav.tpl')
        %end
        <main>
            <div class="main_jubo">
                <div class="container">
                    <h1>CONNECTS NEW BUSINESSES WITH STUDENTS IN SOUTHERN SWEDEN</h1>
                    <h2>Create a quest and find out who your new co-founder or team member will be.
                        Join us and get in touch with more people. All free!</h2>
                    <a href="/login" class="btn red">Create a quest</a>
                    <!--<div class="more"></div>-->
                </div>
            </div>

            <div class="ads">
                <div class="container">
                    <h2>They are looking to connect:</h2>
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
                                        <ul class="tags">
                                            %if tags:
                                                %if any(tag[0] == ad[0] for tag in tags):
                                                    <p>Tags:</p>
                                                %end
                                                %for tag in tags:
                                                    %if tag[0] == ad[0]:
                                                        <li>{{tag[1]}},</li>
                                                    %end
                                                %end
                                            %end
                                        </ul>
                                    </div>
                                    <div class="go"></div>
                                </div>
                            </a>
                        %end
                    %else:
                        <p>Det finns inga annonser än</p>
                    %end
                </div>
            </div>
        </main>
        %include('footer.tpl')
    </body>
</html>
