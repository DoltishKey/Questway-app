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
        <main class="application_page">
            %if user_lvl == 1:
                <a href="/admin_ads/{{ad_info[1]}}" class="get_back">
                    <div class="back_icon"></div>
                    <p>Back to {{ad_info[8]}}</p>
                </a>
            %end
            <div class="applications container">
                    <h4>Applications</h4>
                    <div class="ad_starter">
                        <h2>{{ad_info[3]}}</h2>
                        %if user_lvl == 1 or user_lvl == 2:
                        <div class="more_opt_trigger">
                            <div class="trigger_icon"></div>
                            <div class="trigger_icon"></div>
                            <div class="trigger_icon"></div>
                        </div>
                    </div>
                    <div class="more_ad_opts">
                            <a href="/job/{{ad_info[0]}}">View ad</a>
                            <a href="/admin_denie_ad/{{ad_info[1]}}/{{ad_info[0]}}">Delete ad</a>
                        %end
                    </div>
                            %if not applications:
                                %if ad_info[6] == 1:
                                    <p>Published, but stil no applications...yet.</p>
                                %else:
                                    <p>Waiting to be approved, so there is no applications...yet.</p>
                                    %if user_lvl == 1 and ad_info[6] == 0:
                                        <a href="/admin_approve_ad/{{ad_info[1]}}/{{ad_info[0]}}"><button>Godkänn och publicra annonsen</button></a>
                                        <a href="/admin_denie_ad/{{ad_info[1]}}/{{ad_info[0]}}"><button>Godkänn ej, annonsen tas bort</button></a>
                                    %end
                                %end
                            %end


                % for application in applications:
                    <div class="application_id application" data-application="{{application[0]}}">
                        <div class="applicant_profile applicant_overlay_opener">
                            <div class="num_team">
                                <p>Members</p>
                                %members = sum(applicant[0] == application[0] for applicant in applicants)
                                <h5>{{members}}</h5>
                            </div>
                            <div class="user_icon white"></div>
                            %applier = next(applicant for applicant in applicants if applicant[0] == application[0])
                            <h3>{{applier[1]}}</h3>
                            <div class="label_list">
                                %for this_label in got_labels:
                                    %if this_label[1] == application[0]:
                                        %if this_label[2] == 1:
                                            <div class="got_label" data-label="{{this_label[0]}}" style="display:block; background-color:{{this_label[3]}};"></div>
                                        %else:
                                            <div class="got_label" data-label="{{this_label[0]}}" style="display:none; background-color:{{this_label[3]}};"></div>
                                        %end
                                    %end
                                %end
                            </div>
                        </div>
                        <div class="application_overlay overlay">
                            <div class="applicant_close close_icon"></div>
                            <hr>
                            <div class="container this_label_cont">
                                <div class="heading">
                                    <p>{{ad_info[3]}}</p>
                                    <p>team {{applier[1]}}</p>
                                </div>
                                <div class="message">
                                    <h2>Message</h2>
                                    %if application[2]:
                                        <p>{{application[2]}}</p>
                                    %else:
                                        <p>There is no message.</p>
                                    %end
                                </div>
                                <div class="label_trigger">
                                    <div class="content">
                                        <h3>Labels</h3>
                                    </div>
                                    <div class="to_label_btn">
                                        <div class="label_icon"></div>
                                        <div class="label_list small">
                                            %for this_label in got_labels:
                                                %if this_label[1] == application[0]:
                                                    %if this_label[2] == 1:
                                                        <div class="got_label" data-label="{{this_label[0]}}" style="display:block; background-color:{{this_label[3]}};"><p>{{this_label[4]}}</p></div>
                                                    %else:
                                                        <div class="got_label" data-label="{{this_label[0]}}" style="display:none; background-color:{{this_label[3]}};"><p>{{this_label[4]}}</p></div>
                                                    %end
                                                %end
                                            %end
                                        </div>
                                        <div class="label_arrow"></div>
                                    </div>
                                </div>
                                <div class="application_members">
                                    <h2>Team members</h2>
                                    %for applicant in applicants:
                                        <ul>
                                            %if applicant[0] == application[0]:
                                                <li class="application_member">
                                                    <div class="user_icon red"></div>
                                                    <div class="text">
                                                        <h3>{{applicant[1]}}</h3>
                                                        <p>{{applicant[2]}}</p>
                                                        <p>{{applicant[3]}}</p>
                                                     </div>

                                                </li>
                                                 <hr>
                                            %end
                                        </ul>
                                    %end
                                </div>
                                %if user_lvl == 1:
                                    <a class="remove_application" href="/admin_remove_application/{{ad_info[0]}}/{{application[0]}}">Ta bort ansökan</a>
                                %end
                            </div>
                        </div>
                        <div class="label_overlay">
                            <div class="label_close">
                                <div class="back_icon"></div>
                                <p>Back</p>
                            </div>
                            <hr>
                            <div class="container this_label_cont">
                                <div class="heading">
                                    <p>{{ad_info[3]}}</p>
                                    <p>team {{applier[1]}}</p>
                                </div>
                                <div class="label_handeling">
                                    <div class="container">
                                        <h3>Labels</h3>
                                        <div>
                                            <ul>
                                                %for label in labels:
                                                    <li>
                                                        <div class="label" data-label="{{label[0]}}" style="background-color:{{label[3]}};">
                                                            %for this_label in got_labels:
                                                                %if this_label[0] == label[0] and this_label[1] == application[0]:
                                                                    %if this_label[2] == 1:
                                                                        <div class="got_it_icon got_it"></div>
                                                                    %else:
                                                                        <div class="got_it_icon"></div>
                                                                    %end
                                                                %end
                                                            %end
                                                            <p>{{label[2]}}</p>
                                                        </div>
                                                        <div class="edith_label edith_label_icon"></div>
                                                        <form data-formlabel="{{label[0]}}" class="edith_label_from">
                                                            <input class="label_text" name="label_text" data-label="{{label[0]}}" style="border: 4px solid {{label[3]}};" value="{{label[2]}}" maxlength="15">
                                                            <input class="btn submit" type="submit" value="Spara" style="background-color: {{label[3]}}; ">
                                                            <p class="cancel_edith_label">Avbryt</p>
                                                        </form>
                                                    </li>
                                                %end
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                %end
            </div>
        </main>
        %include('footer.tpl')
        <script>
            var ad_nr = {{ad_info[0]}}
        </script>
    </body>
</html>
