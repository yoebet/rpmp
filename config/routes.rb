# -*- encoding : utf-8 -*-

Rpmp::Application.routes.draw do

  namespace :sys do
    root :to => 'admin#facet', as: 'admin_root'
    resources :users do
      collection do
        get 'all', 'disabled'
      end
    end
    resources :departments, :roles, :mods do
      post 'tune_order', :on => :collection
    end
    resources :configs
    resources :dumps, :only => [:index,:create,:destroy] do
      post 'download', :on => :member
    end
    resources :projects do
      get *%w(all inactive), :on => :collection
      resources :role_members, :member_roles do
        get 'edit', :action => 'edit_all', :on => :collection
      end
    end
    resources :announcements do
      post 'issue', :on => :member
    end
    resource :logs, :only => :show
    controller :console, path: 'console', as: 'console' do
      get '/' => :index
      post 'run'
    end
    controller :sessions do
      get 'login' => :new
      post 'login' => :create
      delete 'logout' => :destroy
    end
  end

  controller :personal, path: 'personal', module: 'sys', as: 'personal' do
    get '/' => :index
    get 'edit'
    put 'update'
  end

  resources :projects do
    member do
      get *%w(role_members member_roles members)
    end
    collection do
      get *%w(all inactive activities weeklies issues_statistic
            issues issues_unsolved issues_to_test issues_closed issues_unclosed
            tasks tasks_todo my_tasks my_tasks_todo task_ranks task_matrix)
    end
    resources :attachments do
      member do
        get 'download', 'image'
      end
    end
    resources :modus do
      member do
        get *%w(requirements issues tasks)
      end
    end
    resources :tags, :only => [:index, :show] do
      member do
        get *%w(documents requirements issues tasks)
      end
    end
    resources :comments, :activities, :releases
    resources :documents, :meetings, :customers, :communications, :weeklies do
      get 'history', :on => :member
    end
    resources :requirements do
      get 'uncompleted', :on => :collection
      get 'history', :on => :member
    end
    resources :goals, :milestones, :controller => 'goals' do
      member do
        get 'release', 'history'
      end
    end
    resources :tests do
      get 'history', :on => :member
      resources :issues, :controller => :test_issues do
        collection do
          get 'unsolved', 'to_test'
        end
        get 'history', :on => :member
      end
    end
    resources :issues do
      collection do
        get *%w(unsolved to_test closed unclosed associated statistic)
      end
      member do
        get *%w(associated history solve regress reopen)
      end
    end
    resources :tasks, :my_tasks do
      collection do
        get *%w(todo requirements issues)
      end
      member do
        get *%w(history requirements issues)
        post *%w(receive rank)
      end
    end
    resource :task_statistics, only: 'show' do
      get 'ranks','matrix'
    end

    resources :revisions do
      get 'entries', :on => :member
      collection do
        get 'statistic'
        get 'diff/:entry_id(/:diff_with)', action: 'diff'
        get 'source/:entry_id', :action => 'source'
      end
    end
    post ':controller/:id/pm_confirm', :action => :pm_confirm
  end

  resources :announcements, :only => [:index, :show] do
    get 'current', :on => :collection
  end
  resources :departments, :only => [:index] do
    get 'users', :on => :member
  end
  resources :messages, :except => :update do
    collection do
      get 'received', 'sent'
    end
    get 'reply', :on => :member
  end

  match 'announcement' => 'announcements#current', :as => 'current_announcement'
  root :to => 'projects#index'

end
