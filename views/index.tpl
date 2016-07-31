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
                    <h1>WE CONNECTS ENTREPENURES WITH STUDENTS</h1>
                    <h2>Sudent and want to get some real experience and put your skills in use? Work with an entrepenure with anything from projects to longterm commitments!</h2>
                    <div class="btn">Join us</div>
                    <!--<div class="more"></div>-->
                </div>
            </div>

            <div class="ads">
                <div class="container">
                    <h2>They want connections:</h2>
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
